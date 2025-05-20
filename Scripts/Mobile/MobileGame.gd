extends Node2D

var chat

func _ready() -> void:
	 # Set local screen size to HUD
	$HUD.size = GameManager.Players[multiplayer.get_unique_id()].player_screen_size

	chat = $HUD/ChatManager
	chat.configure_for_mobile()

func send_input_to_pc(action):
	rpc_id(1, "receive_player_action", action)
