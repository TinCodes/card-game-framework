extends Node2D

func _ready() -> void:
	SceneManager.main_scene = self
	SceneManager.scene_instance = $MobileLogin
