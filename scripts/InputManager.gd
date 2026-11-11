extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var item: Variant = Collision.check_for_first_collision()
		
		if event.is_pressed():
			EventBus.mouse_pressed.emit(item, event.position)
		elif event.is_released():
			EventBus.mouse_released.emit()
	elif event is InputEventMouseMotion:
		EventBus.mouse_moved.emit(event.position)
