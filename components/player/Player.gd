extends Node2D

class_name Player

var shield: int
var current_action: int

@onready var health_reference: RichTextLabel = $Health
@onready var shield_reference: RichTextLabel = $Shield
@onready var action_reference: RichTextLabel = $Actions

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_refresh_texts()
	
func setup() -> void:
	_refresh_texts()
	
func _refresh_texts() -> void:
	_update_health_text()
	_update_shield_text()
	_update_action_text()
	
func _update_health_text() -> void:
	health_reference.text = tr("UI_BATTLE_HEALTH").format(
		{"current": GameState.current_health, "max": GameState.full_health})
	
func _update_shield_text() -> void:
	shield_reference.text = tr("UI_BATTLE_SHIELD").format({"current": shield})
	
func _update_action_text() -> void:
	action_reference.text = tr("UI_BATTLE_ACTIONS").format(
		{"current": current_action, "max": GameState.maximum_action})
	
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
	
