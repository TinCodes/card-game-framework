extends Node2D

func _ready() -> void:
	$HUD/Debug/DebugText.text += "Connected"

func send_input_to_pc(action):
	rpc_id(1, "receive_player_action", action)

# Function activated from server on connection established
@rpc("authority")
func receive_cards(cards):
	print("Received cards: ", cards)

# Function activated from server on connection established
@rpc("authority")
func receive_deck(deck):
	print("Received deck")

@rpc("any_peer")
func update_client_game_state(data):
	print("Updated game state: ", data)
