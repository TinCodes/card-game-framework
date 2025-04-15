extends Node2D

const SERVER_IP = "192.168.1.18"  # Change to PC’s local IP
const PORT = 9000

var scene_instance

func _ready() -> void:
	scene_instance = $MobileScreen
	Network.game_start.connect(_on_game_start)

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

func _on_game_start():
	load_scene("MobileGame")
