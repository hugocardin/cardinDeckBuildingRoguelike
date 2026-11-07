extends Node2D

var shield
var current_action

var health_reference
var shield_reference
var action_reference

func _ready() -> void:
	health_reference = $Health
	shield_reference = $Shield
	action_reference = $Actions
	
	EventBus.player_turn_started.connect(_on_player_turn_started)
	
func setup():
	_update_health_text()
	_update_shield_text()
	_update_action_text()
	
func _update_health_text():
	health_reference.text = str(GameState.current_health) + " / " + str(GameState.full_health) + " PV"
	
func _update_shield_text():
	shield_reference.text = str(shield) + " shield"

func _update_action_text():
	action_reference.text = str(current_action) + " / " + str(GameState.maximum_action)
	
func add_shield(shield_added: int):
	shield += shield_added
	_update_shield_text()
	
func take_damage(damage: int):
	damage -= shield
	
	if damage <= 0:
		shield = abs(damage)
	else:
		shield = 0
		GameState.current_health -= damage
	
	if GameState.current_health <= 0:
		GameState.current_health = 0
	
	_update_health_text()
	_update_shield_text()
	
func _on_player_turn_started():
	shield = 0
	current_action = GameState.maximum_action
	
	_update_shield_text()
	_update_action_text()

func decrement_actions():
	current_action -= 1
	_update_action_text()

func has_actions() -> bool:
	return current_action > 0
	
