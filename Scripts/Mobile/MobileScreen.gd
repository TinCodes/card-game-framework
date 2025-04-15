extends Node2D

func _ready():
	$Menu/Button.disabled = true

func _on_button_down() -> void:
	var player_data = Player.new()
	player_data.player_os = OS.get_name()
	player_data.player_name = $Menu/PlayerName.text
	Network.connect_to_server(player_data)

func _on_player_name_text_changed(new_text: String) -> void:
	$Menu/Button.disabled = new_text.is_empty()
