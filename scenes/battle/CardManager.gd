class_name CardManager

extends Node2D

const DRAG_THRESHOLD: float = 5.0

var pressed_item: Variant
var press_position: Vector2
var is_dragging: bool
var screen_size: Vector2
var is_hovering_on_card: bool

var player_hand_reference: PlayerHand
var discard_reference: Discard
var enemies_reference: Enemies
var deck_reference: Deck
var player_reference: Player
var battle_reference: Battle

func _ready() -> void:
	pressed_item = null
	is_dragging = false
	
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	discard_reference = $"../Discard"
	enemies_reference = $"../Enemies"
	deck_reference = $"../Deck"
	player_reference = $"../Player"
	battle_reference = $".."
	
	EventBus.card_hovered.connect(_on_hovered_card)
	EventBus.card_hovered_off.connect(_on_hovered_off_card)
	
	EventBus.mouse_pressed.connect(_on_mouse_pressed)
	EventBus.mouse_moved.connect(_on_mouse_moved)
	EventBus.mouse_released.connect(_on_mouse_released)
	
func _on_mouse_pressed(item: Variant, pos: Vector2) -> void:
	if battle_reference.is_player_turn():
		pressed_item = item
		press_position = pos
		is_dragging = false

func _on_mouse_moved(pos: Vector2) -> void:
	if pressed_item is Card:
		if not is_dragging:
			if pos.distance_to(press_position) > DRAG_THRESHOLD:
				is_dragging = true
				pressed_item.scale = Constants.CARD_SCALE_DEFAULT
		if is_dragging and pressed_item is Card and player_reference.has_actions():
			var mouse_pos: Vector2 = get_global_mouse_position()
			pressed_item.position = Vector2(
				clamp(mouse_pos.x, 0, screen_size.x),
				clamp(mouse_pos.y, 0, screen_size.y)
			)

func _on_mouse_released() -> void:
	if pressed_item is Card:
		if is_dragging:
			finish_drag()
		else:
			print("Card tapped")
	elif battle_reference.is_player_turn():
		if pressed_item is EnemyCard:
			# TODO connect to show enemy card details
			EventBus.enemy_card_clicked.emit(pressed_item)
		elif pressed_item is Deck:
			EventBus.left_mouse_button_pressed_on_deck.emit()
	
	pressed_item = null
	is_dragging = false
	
func finish_drag() -> void:
	if pressed_item is Card:
		var enemy_card_found: EnemyCard = Collision.check_for_enemy_card()
		is_hovering_on_card = false
		
		if battle_reference.is_player_turn() && player_reference.has_actions() and enemy_card_found:
			pressed_item.scale = Constants.CARD_SCALE_BIG
			player_reference.decrement_actions()
			player_hand_reference.remove_card_to_hand(pressed_item)
			discard_reference.add_card(pressed_item.instance)
			deck_reference.draw_card()
			
			if pressed_item.attribut_shield:
				player_reference.add_shield(pressed_item.attribut_shield)
				
			enemy_card_found.take_damage(pressed_item.attribut_attack)
			pressed_item.queue_free()
		else:
			pressed_item.scale = Constants.CARD_SCALE_DEFAULT
			player_hand_reference.add_card_to_hand(pressed_item)
			

func _on_hovered_card(card: Card) -> void:
	if !is_hovering_on_card:
		highlight_card(card, true)
		is_hovering_on_card = true
	
func _on_hovered_off_card(card: Card) -> void:
	if !is_dragging:
		highlight_card(card, false)
		
		var new_hovered_card: Card = Collision.check_for_card()
		if new_hovered_card:
			highlight_card(new_hovered_card, true)
		else:
			is_hovering_on_card = false
	
func highlight_card(card: Card, is_hoverred: bool) -> void:
	if is_hoverred:
		card.scale = Constants.CARD_SCALE_BIG
		card.z_index = 2
	else:
		card.scale = Constants.CARD_SCALE_DEFAULT
		card.z_index = 1
