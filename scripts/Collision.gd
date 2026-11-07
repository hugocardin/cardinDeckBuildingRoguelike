extends Node2D

func check_for_card():
	return _get_card_with_highest_z_index(_check_for_colliders(), "Card")

func check_for_enemy_card():
	return _get_card_with_highest_z_index(_check_for_colliders(), "EnemyCard")

func check_for_first_collision():
	return _get_card_with_highest_z_index(_check_for_colliders())

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
