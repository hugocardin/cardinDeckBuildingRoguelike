extends Node2D

var current_health = 22
var full_health = 45
var shield = 22
var current_action
var maximum_action = 3

var health_reference
var shield_reference
var action_reference

func _ready() -> void:
	health_reference = $Health
	shield_reference = $Shield
	action_reference = $Actions
	
	_update_health_text()
	_update_shield_text()
	_update_action_text()
	
	EventBus.player_turn_started.connect(_on_player_turn_started)
	
func _update_health_text():
	health_reference.text = str(current_health) + " / " + str(full_health) + " PV"
	
func _update_shield_text():
	shield_reference.text = str(shield) + " shield"

func _update_action_text():
	action_reference.text = str(current_action) + " / " + str(maximum_action)
	
func add_shield(shield_added: int):
	shield += shield_added
	_update_shield_text()
	
func take_damage(damage: int):
	damage -= shield
	
	if damage <= 0:
		shield = abs(damage)
	else:
		shield = 0
		current_health -= damage
	
	if current_health <= 0:
		current_health = 0
	
	_update_health_text()
	_update_shield_text()
	
func is_dead() -> bool:
	return current_health <= 0
	
func _on_player_turn_started():
	shield = 0
	current_action = maximum_action
	
	_update_shield_text()
	_update_action_text()

func decrement_actions():
	current_action -= 1
	_update_action_text()

func has_actions() -> bool:
	return current_action > 0
	
