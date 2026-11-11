extends Node2D

func check_for_card() -> Card:
	return _get_item_with_highest_z_index(_check_for_colliders(), "Card")

func check_for_enemy_card() -> EnemyCard:
	return _get_item_with_highest_z_index(_check_for_colliders(), "EnemyCard")

func check_for_first_collision() -> Variant:
	return _get_item_with_highest_z_index(_check_for_colliders())

func _check_for_colliders() -> Array[Dictionary]:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	
	return space_state.intersect_point(parameters)
	
func _get_item_with_highest_z_index(colliders: Array[Dictionary], 
									expected_class_name: String = "") -> Variant:
	var highest_z_card: Variant = null
	var highest_z_index: int = -9999
	
	for item: Dictionary in colliders:
		var item_parent: Variant = item.collider.get_parent()
		
		# Vérifie le class_name du script
		if expected_class_name != "":
			var script: GDScript = item_parent.get_script()
			if not script or script.get_global_name() != expected_class_name:
				continue
		
		if item_parent.z_index > highest_z_index:
			highest_z_card = item_parent
			highest_z_index = item_parent.z_index
	
	return highest_z_card
