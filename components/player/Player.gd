extends Node2D

var current_health = 2
var full_health = 45
var shield = 2

var health_reference
var shield_reference

func _ready() -> void:
	health_reference = $Health
	shield_reference = $Shield
	
	_update_health_text()
	_update_shield_text()
	
func _update_health_text():
	health_reference.text = str(current_health) + " / " + str(full_health) + " PV"
	
func _update_shield_text():
	shield_reference.text = str(shield) + " shield"
	
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
