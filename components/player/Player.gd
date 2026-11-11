extends Node2D

class_name Player

var shield: int
var current_action: int

var health_reference: RichTextLabel
var shield_reference: RichTextLabel
var action_reference: RichTextLabel

func _ready() -> void:
	health_reference = $Health
	shield_reference = $Shield
	action_reference = $Actions
	
func setup() -> void:
	_update_health_text()
	_update_shield_text()
	_update_action_text()
	
func _update_health_text() -> void:
	health_reference.text = str(GameState.current_health) + " / " + str(GameState.full_health) + " PV"
	
func _update_shield_text() -> void:
	shield_reference.text = str(shield) + " shield"

func _update_action_text() -> void:
	action_reference.text = str(current_action) + " / " + str(GameState.maximum_action)
	
func add_shield(shield_added: int) -> void:
	shield += shield_added
	_update_shield_text()
	
func take_damage(damage: int) -> void:
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
	
func player_turn_started() -> void:
	shield = 0
	current_action = GameState.maximum_action
	
	_update_shield_text()
	_update_action_text()

func decrement_actions() -> void:
	current_action -= 1
	_update_action_text()

func has_actions() -> bool:
	return current_action > 0
	
