class_name EnemyCard

extends Node2D

var attribut_card_name
var attribute_health
var attribute_attack

var health_reference
var attack_reference
var enemy_card_image_reference

func _ready() -> void:
	health_reference = $Health
	attack_reference = $Attack
	enemy_card_image_reference = $EnemyCardImage

func setup(card_name, attributes, card_scale: Vector2 = Vector2.ONE):
	attribut_card_name = card_name
	scale = card_scale
	
	attribute_health = attributes["health"]
	attribute_attack = attributes["attack"]
	
	health_reference.text = str(attribute_health)
	attack_reference.text = str(attribute_attack)
	
	var image_path = "res://assets/enemy_cards/" + card_name + ".jpg"
	enemy_card_image_reference.texture = load(image_path)
	
func get_width() -> float:
	return enemy_card_image_reference.get_rect().size.x * scale.x

func take_damage(damage: int):
	attribute_health -= damage
	
	if attribute_health <= 0:
		attribute_health = 0
		EventBus.enemy_is_dead.emit(self)
		
	health_reference.text = str(attribute_health)
