class_name CardManager

extends Node2D

const DRAG_THRESHOLD: float = 5.0
const DRAG_Z_INDEX := 10

var pressed_item: Variant
var press_position: Vector2
var is_dragging: bool
var screen_size: Vector2

@onready var player_hand_reference: PlayerHand = $"../PlayerHand"
@onready var discard_reference: Discard = $"../Discard"
@onready var enemies_reference: Enemies = $"../Enemies"
@onready var deck_reference: Deck = $"../Deck"
@onready var player_reference: Player = $"../Player"
@onready var battle_reference: Battle = $".."

func _ready() -> void:
	pressed_item = null
	is_dragging = false
	
	screen_size = get_viewport_rect().size
	
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
				pressed_item.z_index = DRAG_Z_INDEX
		if is_dragging and pressed_item is Card and player_reference.has_actions():
			var mouse_pos: Vector2 = get_global_mouse_position()
			pressed_item.position = Vector2(
				clamp(mouse_pos.x, 0, screen_size.x),
				clamp(mouse_pos.y, 0, screen_size.y)
			)

func _on_mouse_released() -> void:
	if pressed_item is Card and is_dragging:
		finish_drag()
	elif battle_reference.is_player_turn():
		if pressed_item is Card:
			pressed_item.on_tap()
		elif pressed_item is EnemyCard:
			pressed_item.on_tap()
		elif pressed_item is Deck:
			deck_reference.on_tap()
		elif pressed_item is Discard:
			discard_reference.on_tap()
	
	pressed_item = null
	is_dragging = false
	
func finish_drag() -> void:
	if pressed_item is Card:
		var enemy_card_found: EnemyCard = Collision.check_for_enemy_card()
		
		if battle_reference.is_player_turn() && player_reference.has_actions() and enemy_card_found:
			player_reference.decrement_actions()
			player_hand_reference.remove_card_to_hand(pressed_item)
			discard_reference.add_card(pressed_item.instance)
			deck_reference.draw_card()
			
			if pressed_item.attribut_shield:
				player_reference.add_shield(pressed_item.attribut_shield)
				
			enemy_card_found.take_damage(pressed_item.attribut_attack)
			pressed_item.queue_free()
		else:
			pressed_item.z_index = 0
			player_hand_reference.add_card_to_hand(pressed_item)
