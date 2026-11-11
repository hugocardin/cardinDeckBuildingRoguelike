extends Node2D

var is_player_turn: bool

func _ready() -> void:
	EventBus.player_turn_started.connect(_on_player_turn_started)
	EventBus.player_turn_ended.connect(_on_player_turn_ended)

func _input(event: InputEvent) -> void:
	if !is_player_turn:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var item = Collision.check_for_first_collision()
		if event.is_pressed():
			EventBus.mouse_pressed.emit(item, event.position)
		else:
			EventBus.mouse_released.emit()
	elif event is InputEventMouseMotion:
		EventBus.mouse_moved.emit(event.position)

func _on_player_turn_started():
	is_player_turn = true

func _on_player_turn_ended():
	is_player_turn = false
