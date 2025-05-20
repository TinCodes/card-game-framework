extends Node2D

func _ready() -> void:
	SceneManager.main_scene = self
	SceneManager.scene_instance = $MobileLogin
	$MobileLogin/Menu.size = DisplayServer.screen_get_size()
