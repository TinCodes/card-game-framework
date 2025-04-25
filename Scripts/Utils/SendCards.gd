extends Control

signal send_full_deck
signal send_specific_cards(cards: Array)

func _ready():
	# Hide card selector initially
	$InfoBox/Send.hide()
	$InfoBox/Cancel.hide()
	$InfoBox/CardList.hide()

	# Populate list with card names
	var card_db = preload("res://Scripts/DBs/CardDatabase.gd")
	for card_name in card_db.CARDS.keys():
		$CardList.add_item(card_name)

func _on_send_deck_button_pressed():
	emit_signal("send_full_deck")
	queue_free()

func _on_send_specific_cards_button_pressed():
	# Toggle buttons and list
	$InfoBox/Deck.hide()
	$InfoBox/Card.hide()
	$InfoBox/Send.show()
	$InfoBox/Cancel.show()
	$InfoBox/CardList.show()
	
	var selected_cards = []
	for index in $InfoBox/CardList.get_selected_items():
		selected_cards.append($InfoBox/CardList.get_item_text(index))

	if selected_cards.size() > 0:
		emit_signal("send_specific_cards", selected_cards)
		queue_free()

func _on_card_selector_item_selected(index):
	var card_name = $InfoBox/CardList.get_item_text(index)
	emit_signal("send_specific_cards", card_name)
