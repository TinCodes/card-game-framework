extends Node2D

const PORT = 9000

func _ready():
	# Create server instance
	start_server()

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4)  # Allow up to 4 phones to connect
	print('on create: ', error)
	if error != OK:
		print("Failed to start server!")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_client_connected)
	print("Server started on port %d" % PORT)

func _on_client_connected(id):
	$RichTextLabel.text += "\nClient connected: " + str(id)
	send_game_state_to_clients()

@rpc("authority")
func send_game_state_to_clients():
	# TODO: Modify with a Singleton gamestate
	var game_state = {"score": 100, "player_positions": Vector2(50, 50)}
	rpc("update_client_game_state", game_state)

@rpc("any_peer")
func update_client_game_state(data):
	print("Game state received on client: ", data)	

@rpc("any_peer")
func receive_player_action(action):
	print("Action received: ", action)
	# Process input (e.g., move character, update score)
