extends Node2D

const HOST_USERNAME = "Admin"
const CHATBOX_MAX_LINES = 3

var card_db_ref
var send_cards_HUD_ref
var chat

var debugger

func _ready():
	# Preloads
	card_db_ref = preload("res://Scripts/DBs/CardDatabase.gd")
	send_cards_HUD_ref = preload("res://Scenes/PC/HUD_peer_send_cards.tscn")

	# Instantiation
	chat = $HUD/ChatManager
	chat.configure_for_pc()

	# Debug
	Network.debug_print.connect(_on_debug)

func _on_host_pressed() -> void:
	# Create server
	Network.start_server()

func _on_init_pressed() -> void:
	Network.initialize_game.rpc("Mobile/mobile_game")

#func prompt_master_for_cards(id):
	#$HUD.add_child(send_cards_HUD_ref)
	#send_cards_HUD_ref.connect("send_full_deck", Callable(self, "_on_send_full_deck").bind(id))
	#send_cards_HUD_ref.connect("send_specific_cards", Callable(self, "_on_send_specific_card").bind(id))

#func _on_send_full_deck(peer_id):
	## Get all card names from the database
	#var deck = card_db_ref.CARDS.keys()
	#deck.shuffle()
	#rpc_id(peer_id, "receive_deck", deck)

#func _on_send_specific_card(card_name: String, peer_id):
	#var card_data = { card_name: preload("res://Scripts/DBs/CardDatabase.gd").CARDS[card_name] }
	#rpc_id(peer_id, "initialize_client_with_cards", card_data)

#func send_text(new_text: String):
	#new_text = new_text.strip_edges()
	#if new_text == "":
		#return
	#if $ChatPanel/ChatOptions.selected == 0:
		#Network.send_message_to_all(new_text, HOST_USERNAME)
	#else:
		#Network.send_private_message.rpc(HOST_USERNAME, $ChatPanel/ChatOptions.selected, new_text)
	#$ChatPanel/ChatBox.text = ""

#func _unhandled_input(event):
	## Make the Enter key send the message from the ChatBox
	#if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		#if $ChatPanel/ChatBox.has_focus():
			#send_text($ChatPanel/ChatBox.text)
			#get_viewport().set_input_as_handled()

#func _on_chat_box_text_changed():
	#var lines = $ChatPanel/ChatBox.get_line_count()
	#if lines > CHATBOX_MAX_LINES:
		#$ChatPanel/ChatBox.scroll_vertical = lines - CHATBOX_MAX_LINES

#func _on_send_button_pressed():
	#send_text($ChatPanel/ChatBox.text)

#func _on_message_received(player_name, _sender_id, message, is_private):
	#var prefix = "[PRIVATE]" if is_private else ""
	#var display_name = "%s%s:" % [prefix, player_name]
	#
	## Create label with richtext
	#var rich_label = RichTextLabel.new()
	#rich_label.bbcode_enabled = true
	#rich_label.fit_content = true
	#rich_label.scroll_active = false
	#rich_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#rich_label.custom_minimum_size = Vector2(0, 24)
	#rich_label.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)
#
	## Format the message using BBCode
	#var formatted_text := "[b]%s[/b]\n    %s" % [display_name, message]
	#rich_label.text = formatted_text
	#
	## Differentiate private messages
	#if is_private:
		#rich_label.add_theme_color_override("default_color", Color(1, 0.4, 0.4))
	#
	#$ChatPanel/ScrollContainer/Messages.add_child(rich_label)
#
	## Scroll to bottom
	#await get_tree().process_frame
	#$ChatPanel/ScrollContainer.scroll_vertical = $ChatPanel/ScrollContainer.get_v_scroll_bar().max_value

func _on_debug(print_text):
	$RichTextLabel.text += "\n"
	$RichTextLabel.text += str(print_text)
