class_name PlayerHand

extends Node2D

var cards : Array[Card]
var hand_y: float

func _ready() -> void:
	var h: float = get_viewport().get_visible_rect().size.y
	hand_y = h - Constants.PLAYER_HAND_BOTTOM_MARGIN - Constants.CARD_HEIGHT / 2.0
	cards = []

func add_card_to_hand(card: Card, duration: float = Constants.CARD_DEFAULT_MOVE_DURATION) -> void:
	if card not in cards:
		cards.insert(0, card)
		update_hand_positions(duration)
	else:
		animate_card_to_position(card, card.starting_position, duration)
		
func remove_card_to_hand(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		update_hand_positions(Constants.CARD_DEFAULT_MOVE_DURATION)

func update_hand_positions(duration: float) -> void:
	for i in range(cards.size()):
		var card: Card = cards[i]
		var new_position: Vector2 = Vector2(calculate_card_position(i), hand_y)
		card.starting_position = new_position
		animate_card_to_position(card, new_position, duration)

func calculate_card_position(index: int) -> float:
	var spacing: float = 20.0
	var side_margin: float = 40.0
	var available: float = get_viewport_rect().size.x - side_margin * 2
	var total_spacing: float = spacing * (cards.size() - 1)
	var used: float = Constants.CARD_WIDTH * cards.size() + total_spacing
	var start_x: float = side_margin + (available - used) / 2
	
	return start_x + index * (Constants.CARD_WIDTH + spacing) + Constants.CARD_WIDTH / 2
	
func animate_card_to_position(card: Node2D, target_position: Vector2, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "position", target_position, duration)
