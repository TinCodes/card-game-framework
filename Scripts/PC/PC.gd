extends Node2D

const PORT = 9000
var card_db_ref
var send_cards_HUD_ref

var debugger

func _ready():
	# Preload all standard cards in DB
	card_db_ref = preload("res://Scripts/DBs/CardDatabase.gd")
	send_cards_HUD_ref = preload("res://Scenes/PC/HUD_peer_send_cards.tscn")
	
	# Debug
	Network.debug_print.connect(_on_debug)

#func _on_client_connected(id):
	#$RichTextLabel.text += "\nClient connected: " + str(id)
	
	# Prompt server to choose whether to send a full deck or individual cards
	#prompt_master_for_cards(id)
	# Prompt server to send any other data
	#if prompt_master_for_extras():
		#send_extra_data(id)
	
	# Send signal to initialize
	#rpc_id(id, "initialize_client")
	
	# Update game for everyone
	#send_game_state_to_clients()

func _on_host_pressed() -> void:
	# Create server
	Network.start_server()

func prompt_master_for_cards(id):
	$HUD.add_child(send_cards_HUD_ref)
	send_cards_HUD_ref.connect("send_full_deck", Callable(self, "_on_send_full_deck").bind(id))
	send_cards_HUD_ref.connect("send_specific_cards", Callable(self, "_on_send_specific_card").bind(id))

func _on_send_full_deck(peer_id):
	# Get all card names from the database
	var deck = card_db_ref.CARDS.keys()
	deck.shuffle()
	rpc_id(peer_id, "receive_deck", deck)

func _on_send_specific_card(card_name: String, peer_id):
	var card_data = { card_name: preload("res://Scripts/DBs/CardDatabase.gd").CARDS[card_name] }
	rpc_id(peer_id, "initialize_client_with_cards", card_data)

func _on_debug(print_text):
	$RichTextLabel.text += "\n"
	$RichTextLabel.text += str(print_text)
