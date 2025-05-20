extends Control

@onready var scroll_container = $ScrollContainer
@onready var messages = $ScrollContainer/Messages
@onready var chat_box = $ChatBox
@onready var chat_selector = $ChatTargetSelector
@onready var send_button = $Send

const HOST_USERNAME = "Admin"
const SCROLL_BUFFER = 70

var auto_scroll_enabled = true

func _ready():
	Network.message_received.connect(_on_message_received)
	GameManager.player_list_updated.connect(update_players_list)
	send_button.disabled = true

func configure_for_pc():
	send_button.visible = true

func configure_for_mobile():
	update_players_list()
	send_button.visible = false

func update_players_list():
	chat_selector.clear()
	chat_selector.add_item("Everyone", 0)
	if !multiplayer.is_server():
		# Set Host as an always available chat option
		chat_selector.add_item("Host", 1)
	for peer_id in GameManager.Players:
		if multiplayer.get_unique_id() != peer_id:
			var player_name = GameManager.Players[peer_id]["player_name"]
			chat_selector.add_item(player_name, peer_id)

func get_sender_name() -> String:
	if multiplayer.is_server():
		return "Admin"
	elif GameManager.Players.has(multiplayer.get_unique_id()):
		return GameManager.Players[multiplayer.get_unique_id()].player_name
	return "Unknown"

func send_msg():
	var text = chat_box.text.strip_edges()
	if text.is_empty():
		return

	var sender_name = get_sender_name()
	if chat_selector.selected == 0:
		Network.send_message_to_all(text, sender_name)
	else:
		var peer_id = chat_selector.get_selected_id()
		Network.send_private_message(sender_name, peer_id, text)

	chat_box.text = ""
	send_button.disabled = true

func _on_send_button_pressed():
	send_msg()

func _on_text_changed():
	var text = chat_box.text.strip_edges()
	send_button.disabled = text.is_empty()

func _on_chatbox_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			if not event.shift_pressed:
				send_msg()
				get_viewport().set_input_as_handled()

func _on_message_received(player_name: String, _sender_id: int, message: String, is_private: bool):
	var rich_label = RichTextLabel.new()
	rich_label.bbcode_enabled = true
	rich_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	rich_label.fit_content = true
	rich_label.scroll_active = false
	rich_label.selection_enabled = true
	rich_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rich_label.mouse_filter = Control.MOUSE_FILTER_PASS
	rich_label.set("theme_override_constants/line_spacing", 4)
	rich_label.set("theme_override_colors/default_color", "black")

	var is_self = player_name == get_sender_name()
	var tag_color = "red" if is_private else ("blue" if is_self else "grey")
	var prefix = "[PRIVATE] " if is_private else ""
	
	# Message formatting
	var formatted = "[color=%s]%s%s:[/color] %s" % [tag_color, prefix, player_name, message]

	# Emojis: replace :emoji_name: with Unicode
	formatted = formatted.replace(":cat:", "🐱").replace(":dice:", "🎲")
	rich_label.text = formatted

	auto_scroll_enabled = scroll_container.get_v_scroll_bar().max_value
	messages.add_child(rich_label)
	check_scroll()

func check_scroll():
	var scroll_bar = scroll_container.get_v_scroll_bar()
	var scroll_end_value = scroll_container.scroll_vertical + scroll_bar.page
	if (auto_scroll_enabled - SCROLL_BUFFER) <= scroll_end_value:
		await get_tree().process_frame
		scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
