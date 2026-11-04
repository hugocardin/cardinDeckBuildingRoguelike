extends Sprite2D

signal left_mouse_button_pressed_on_card
signal left_mouse_button_pressed_on_deck
signal left_mouse_button_released

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var itemCollided = _get_item_with_highest_z_index(_check_for_colliders_at_cursor())
			
			if itemCollided is Card:
				emit_signal("left_mouse_button_pressed_on_card", itemCollided)
			elif itemCollided is EnemyCard:
				print("Enemy found")
			elif itemCollided is Deck:
				emit_signal("left_mouse_button_pressed_on_deck")
		elif event.is_released():
				emit_signal("left_mouse_button_released")

func _check_for_colliders_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	# parameters.collision_mask = COLLISION_MASK_CARD
	
	return space_state.intersect_point(parameters)
	
func _get_item_with_highest_z_index(colliders, expected_class_name: String = ""):
	if colliders.size() == 0:
		return null
		
	var highest_z_item = null
	var highest_z_index = -9999
	
	for item in colliders:
		var card = item.collider.get_parent()
		
		# Vérifie le class_name du script
		if expected_class_name != "":
			var script = card.get_script()
			if not script or script.get_global_name() != expected_class_name:
				continue
		
		if card.z_index > highest_z_index:
			highest_z_item = card
			highest_z_index = card.z_index
	
	return highest_z_item
