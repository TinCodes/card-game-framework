class_name Player
extends Object

var peer_id
var player_os
var player_name
var player_bg = null
var hand = null
var deck = null

func _to_string() -> String:
	return "Player(peer_id=%s, os=%s, name=%s, bg=%s, hand=%s, deck=%s)" % [
		str(peer_id),
		player_os,
		player_name,
		str(player_bg),
		str(hand),
		str(deck)
	]

func to_dict():
	return {
		"peer_id": peer_id,
		"player_os": player_os,
		"player_name": player_name,
		"player_bg": player_bg,
		"hand": hand,
		"deck": deck
	}

func from_dict(dict):
	peer_id = dict.get("peer_id", null)
	player_os = dict.get("player_os", null)
	player_name = dict.get("player_name", null)
	player_bg = dict.get("player_bg", null)
	hand = dict.get("hand", null)
	deck = dict.get("deck", null)
