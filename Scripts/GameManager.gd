extends Node

signal player_list_updated

var Players : Dictionary[int, Player] = {}

func add_player(id: int, player_data: Player):
	if Players.has(id):
		print("Duplicate player id detected:", id)
		return
	Players[id] = player_data
	player_list_updated.emit()

func remove_player(id: int):
	Players.erase(id)
	player_list_updated.emit()

func clear():
	Players.clear()
	player_list_updated.emit()

func get_player_by_id(peer_id: int) -> Player:
	if Players.has(peer_id):
		return Players[peer_id]
	return null

# Get a player's name by their peer_id
func get_player_name_by_id(peer_id: int) -> String:
	if Players.has(peer_id):
		return Players[peer_id].player_name
	return "Unknown"

#func get_local_player_name() -> String:
	#if multiplayer.is_host():
		#return "Admin"
	#if local_player:
		#return local_player.player_name
	#return "Unknown"

#func register_local_player(player: Player) -> void:
	#local_player = player
	#Players[multiplayer.get_unique_id()] = player

#func register_local_screen_size(size: Vector2):
	#local_screen_size = size

#func unregister_player(peer_id: int) -> void:
	#Players.erase(peer_id)
	#if local_player and peer_id == multiplayer.get_unique_id():
		#local_player = null
