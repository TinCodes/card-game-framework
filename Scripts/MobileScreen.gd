extends Node2D

var player = preload("res://Scripts/Player.gd")

func _ready():
	$Menu/Button.disabled = true

func _on_button_pressed() -> void:
	var player_data = player.new()
	player_data.peer_id = multiplayer.get_unique_id()
	player_data.player_os = OS.get_name()
	player_data.player_name = $Menu/PlayerName.text
	get_parent().connect_to_server(player_data)

func _on_player_name_text_changed(new_text: String) -> void:
	$Menu/Button.disabled = new_text.is_empty()
