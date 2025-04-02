extends Node2D

const SERVER_IP = "192.168.1.18"  # Change to PC’s local IP
const PORT = 9000

var scene_instance

func _ready() -> void:
	scene_instance = $MobileScreen

func connect_to_server(data):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(SERVER_IP, PORT)
	if error != OK:
		print("Failed to connect to server!")
		return
	multiplayer.multiplayer_peer = peer
	print("Connected to server!")
	send_input_to_pc(data)

func unload_scene():
	if (is_instance_valid(scene_instance)):
		scene_instance.queue_free()
	scene_instance = null
	
func load_scene(scene_name):
	unload_scene()
	var scene_path = "res://Scenes/%s.tscn" % scene_name
	var scene_resource = load(scene_path)
	if scene_resource:
		scene_instance = scene_resource.instantiate()
		add_child(scene_instance)

func send_input_to_pc(action):
	rpc_id(1, "receive_player_action", action)  # 1 = PC's peer ID

@rpc("any_peer")
func update_client_game_state(data):
	print("Updated game state: ", data)
