extends Node2D

class_name Discard

var cards: Array[String]

var quantity_reference: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = []
	quantity_reference = $Quantity
	
	_set_card_count()

func add_card(card: String) -> void:
	cards.append(card)
	_set_card_count()

func empty_discard() -> Array[String]:
	var cards_in_discard: Array[String] = cards
	cards = []
	_set_card_count()
	
	return cards_in_discard

func _set_card_count() -> void:
	quantity_reference.text = str(cards.size())
