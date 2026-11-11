class_name CardManager

extends Node2D

const DRAG_THRESHOLD := 5.0

var pressed_item = null
var press_position: Vector2
var is_dragging: bool = false
var screen_size: Vector2
var is_hovering_on_card: bool

var player_hand_reference
var discard_reference
var enemies_reference
var deck_reference
var player_reference

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	discard_reference = $"../Discard"
	enemies_reference = $"../Enemies"
	deck_reference = $"../Deck"
	player_reference = $"../Player"
	
	EventBus.card_hovered.connect(_on_hovered_card)
	EventBus.card_hovered_off.connect(_on_hovered_off_card)
	
	EventBus.mouse_pressed.connect(_on_mouse_pressed)
	EventBus.mouse_moved.connect(_on_mouse_moved)
	EventBus.mouse_released.connect(_on_mouse_released)
	
func _on_mouse_pressed(item, pos):
	pressed_item = item
	press_position = pos
	is_dragging = false

func _on_mouse_moved(pos):
	if pressed_item is Card:
		if not is_dragging:
			if pos.distance_to(press_position) > DRAG_THRESHOLD:
				is_dragging = true
				pressed_item.scale = Constants.CARD_SCALE_DEFAULT
		if is_dragging and pressed_item is Card and player_reference.has_actions():
			var mouse_pos = get_global_mouse_position()
			pressed_item.position = Vector2(
				clamp(mouse_pos.x, 0, screen_size.x),
				clamp(mouse_pos.y, 0, screen_size.y)
			)

func _on_mouse_released():
	if pressed_item is Card:
		if is_dragging:
			finish_drag()
		else:
			print("Card tapped")
	elif pressed_item is EnemyCard:
		EventBus.enemy_card_clicked.emit(pressed_item)
	elif pressed_item is Deck:
		pass
		# TODO Show deck's cards
	
	pressed_item = null
	is_dragging = false
	
func finish_drag():
	if pressed_item is Card:
		var enemy_card_found = Collision.check_for_enemy_card()
		is_hovering_on_card = false
		
		if player_reference.has_actions() and enemy_card_found:
			pressed_item.scale = Constants.CARD_SCALE_BIG
			player_reference.decrement_actions()
			player_hand_reference.remove_card_to_hand(pressed_item)
			discard_reference.add_card(pressed_item.attribut_card_name)
			deck_reference.draw_card()
			
			if pressed_item.attribut_shield:
				player_reference.add_shield(pressed_item.attribut_shield)
				
			enemy_card_found.take_damage(pressed_item.attribut_attack)
			remove_child(pressed_item)
		else:
			pressed_item.scale = Constants.CARD_SCALE_DEFAULT
			player_hand_reference.add_card_to_hand(pressed_item)
			

func _on_hovered_card(card):
	if !is_hovering_on_card:
		highlight_card(card, true)
		is_hovering_on_card = true
	
func _on_hovered_off_card(card):
	if !is_dragging:
		highlight_card(card, false)
		
		var new_hovered_card = Collision.check_for_card()
		if new_hovered_card:
			highlight_card(new_hovered_card, true)
		else:
			is_hovering_on_card = false
	
func highlight_card(card, is_hoverred):
	if is_hoverred:
		card.scale = Constants.CARD_SCALE_BIG
		card.z_index = 2
	else:
		card.scale = Constants.CARD_SCALE_DEFAULT
		card.z_index = 1
