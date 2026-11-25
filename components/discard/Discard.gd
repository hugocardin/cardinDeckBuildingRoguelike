extends Node2D

class_name Discard

var cards: Array[CardInstance]

@onready var quantity_reference: RichTextLabel = $Quantity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = []
	
	_set_card_count()

func add_card(card: CardInstance) -> void:
	cards.append(card)
	_set_card_count()

func empty_discard() -> Array[CardInstance]:
	var cards_in_discard: Array[CardInstance] = cards
	cards = []
	_set_card_count()
	
	return cards_in_discard

func _set_card_count() -> void:
	quantity_reference.text = str(cards.size())

func on_tap() -> void:
	# TODO Implement later
	print("Tapped on Discard")
