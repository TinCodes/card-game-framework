extends Control

var ADDRESS = "127.0.0.1" # fallback IP
var PORT = 6789 # fallback port

signal debug_print

var peer
var card_db_ref
var send_cards_HUD_ref

var pending_player_data = null

var debugger

func _ready() -> void:
	_load_config()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _load_config():
	var config = ConfigFile.new()
	var err = config.load("res://config/network_config.cfg")
	if err == OK:
		ADDRESS = config.get_value("network", "address", ADDRESS)
		PORT = config.get_value("network", "port", PORT)
	else:
		print("Could not load network_config.cfg, using defaults")

func _on_peer_connected(peer_id):
	debug_print.emit("Client connected: " + str(peer_id))
	print("Client connected: " + str(peer_id))

func _on_peer_disconnected(peer_id):
	debug_print.emit("Client Disconnected: " + str(peer_id))
	print("Client Disconnected: " + str(peer_id))
	GameManager.Players.erase(peer_id)

func _on_connected_to_server():
	print("Connected to server")
	if pending_player_data:
		print(">Client: Registering...")
		register_player.rpc_id(1, pending_player_data.to_dict(), multiplayer.get_unique_id())

func _on_connection_failed():
	print("Connection failed")
	multiplayer.multiplayer_peer = null

func start_server():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4)
	if error != OK:
		print("Failed to start server: " + str(error))
		return error
	multiplayer.multiplayer_peer = peer
	
	debug_print.emit("Server started on port %s" % str(PORT))
	print("Server started on port %d" % PORT)

func connect_to_server(player_data: Player):
	# Set data before creating peer
	pending_player_data = player_data
	# Create peer to make connection
	print(ADDRESS)
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	if error != OK:
		print("Failed to connect to server!")
		return
	multiplayer.multiplayer_peer = peer
	print("Client peer created")

@rpc("any_peer", "reliable")
func register_player(player_data: Dictionary, peer_id: int):
	# Reconstruct player data from network
	var new_player = Player.new()
	new_player.from_dict(player_data)

	# Check if the ID is already connected
	if GameManager.Players.has(peer_id):
		print("Player with peer_id already exists")
		return
	
	# Assign peer_id to the new Player instance
	new_player.peer_id = peer_id
	GameManager.Players[peer_id] = new_player
	debug_print.emit("Player registered: " + str(peer_id) + " [" + new_player.player_name + "]")
	print("Player registered with info: ", new_player.to_string())

@rpc("call_local")
func initialize_game(scene_name: String):
	if SceneManager:
		if !multiplayer.is_server():
			SceneManager.load_scene(scene_name)
	else:
		print("SceneManager not found")

# Send signal to initialize
#rpc_id(id, "initialize_client")

# Update game for everyone
#send_game_state_to_clients()

#@rpc("any_peer", "call_local")
#func send_player_info(player_data: Player, peer_id: int):
	# Send player info
	#rpc("update_client_game_state", player_data)
	
	# Prompt server to choose whether to send a full deck or individual cards
	#prompt_master_for_cards(id)
	# Prompt server to send any other data
	#if prompt_master_for_extras():
		#send_extra_data(id)
	#pass
