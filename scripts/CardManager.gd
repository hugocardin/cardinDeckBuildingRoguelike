class_name CardManager

extends Node2D

var card_being_dragged
var screen_size
var is_hovering_on_card

var player_hand_reference
var input_manager_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	
	input_manager_reference = $"../InputManager"
	input_manager_reference.connect("left_mouse_button_pressed_on_card", start_drag)
	input_manager_reference.connect("left_mouse_button_released", finish_drag)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
											  clamp(mouse_pos.y, 0, screen_size.y))

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	
func finish_drag():
	if card_being_dragged:
		card_being_dragged.scale = Vector2(1.05, 1.05)
		var enemy_card_found = _check_for_enemy_card()
		
		if enemy_card_found:
			player_hand_reference.remove_card_to_hand(card_being_dragged)
		else:
			player_hand_reference.add_card_to_hand(card_being_dragged)
		
		card_being_dragged = null

func _check_for_card():
	return _get_card_with_highest_z_index(_check_for_colliders(), "Card")

func _check_for_enemy_card():
	return _get_card_with_highest_z_index(_check_for_colliders(), "EnemyCard")

func _check_for_colliders():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	
	return space_state.intersect_point(parameters)
	
func _get_card_with_highest_z_index(colliders, expected_class_name: String = ""):
	var highest_z_card = null
	var highest_z_index = -9999
	
	for item in colliders:
		var card = item.collider.get_parent()
		
		# Vérifie le class_name du script
		if expected_class_name != "":
			var script = card.get_script()
			if not script or script.get_global_name() != expected_class_name:
				continue
		
		if card.z_index > highest_z_index:
			highest_z_card = card
			highest_z_index = card.z_index
	
	return highest_z_card

func connect_card_signals(card):
	card.connect("hovered", _on_hovered_card)
	card.connect("hovered_off", _on_hovered_off_card)

func _on_hovered_card(card):
	if !is_hovering_on_card:
		highlight_card(card, true)
		is_hovering_on_card = true
	
func _on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		
		var new_hovered_card = _check_for_card()
		if new_hovered_card:
			highlight_card(new_hovered_card, true)
		else:
			is_hovering_on_card = false
	
func highlight_card(card, is_hoverred):
	if is_hoverred:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
