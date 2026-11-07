extends Node2D

var cards

var quantity_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = []
	quantity_reference = $Quantity
	
	_set_card_count()

func add_card(card):
	cards.append(card)
	_set_card_count()

func empty_discard():
	var cards_in_discard = cards
	cards = []
	_set_card_count()
	
	return cards_in_discard

func _set_card_count():
	quantity_reference.text = str(cards.size())
