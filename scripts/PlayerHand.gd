class_name PlayerHand

extends Node2D

const CARD_WIDTH = 250
const HAND_Y_POSITION = 890
const DEFAULT_CARD_MOVE_DURATION = 0.1

var cards : Array = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card: Card, duration: float = DEFAULT_CARD_MOVE_DURATION):
	if card not in cards:
		cards.insert(0, card)
		update_hand_positions(duration)
	else:
		animate_card_to_position(card, card.starting_position, duration)
		
func remove_card_to_hand(card: Card):
	if card in cards:
		cards.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_DURATION)

func update_hand_positions(duration: float):
	for i in range(cards.size()):
		var card = cards[i]
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		card.starting_position = new_position
		animate_card_to_position(card, new_position, duration)

func calculate_card_position(index):
	var total_width = (cards.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func animate_card_to_position(card: Node2D, target_position: Vector2, duration: float):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "position", target_position, duration)
