extends Node

var main_scene: Node = null
var scene_instance: Node = null

func load_scene(scene_path: String):
	unload_scene()
	var path = "res://Scenes/%s.tscn" % scene_path
	var scene = load(path)
	if scene:
		scene_instance = scene.instantiate()
		main_scene.add_child(scene_instance)
	else:
		print("Failed to load scene: ", scene_path)

func unload_scene():
	if scene_instance and is_instance_valid(scene_instance):
		scene_instance.queue_free()
	scene_instance = null
