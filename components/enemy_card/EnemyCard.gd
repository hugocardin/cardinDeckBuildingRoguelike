class_name EnemyCard

extends Node2D

var attribut_card_id: String
var attribute_health: int
var attribute_attack: int

var health_reference: RichTextLabel
var attack_reference: RichTextLabel
var enemy_card_image_reference: Sprite2D

func _ready() -> void:
	health_reference = $Health
	attack_reference = $Attack
	enemy_card_image_reference = $EnemyCardImage

func setup(card_id: String, attributes: Dictionary, card_scale: Vector2 = Vector2.ONE) -> void:
	attribut_card_id = card_id
	scale = card_scale
	
	attribute_health = attributes["health"]
	attribute_attack = attributes["attack"]
	
	health_reference.text = str(attribute_health)
	attack_reference.text = str(attribute_attack)
	
	var image_path: String = "res://assets/enemy_cards/" + card_id + ".jpg"
	enemy_card_image_reference.texture = load(image_path)
	
func get_width() -> float:
	return enemy_card_image_reference.get_rect().size.x * scale.x

func take_damage(damage: int) -> void:
	attribute_health -= damage
	
	if attribute_health <= 0:
		attribute_health = 0
		EventBus.enemy_is_dead.emit(self)
		
	health_reference.text = str(attribute_health)
