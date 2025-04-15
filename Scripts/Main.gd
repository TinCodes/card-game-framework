extends Node

func _ready():
	print(OS.get_name())
	if OS.get_name() == "Android" || OS.get_name() == "iOS":
		call_deferred("load_mobile_ui")
	else:
		call_deferred("load_pc_ui")

func load_mobile_ui():
	get_tree().change_scene_to_file("res://Scenes/Mobile/main_mobile.tscn")

func load_pc_ui():
	get_tree().change_scene_to_file("res://Scenes/PC/pc_screen.tscn")
