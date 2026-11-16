class_name EnemyCard

extends Node2D

var attribut_card_id: String
var attribute_health: int
var attribute_attack: int

var health_reference: RichTextLabel
var attack_reference: RichTextLabel
var name_reference: RichTextLabel
var enemy_card_image_reference: Sprite2D
var enemy_character_image_reference: Sprite2D

func _ready() -> void:
	health_reference = $Health
	attack_reference = $Attack
	name_reference = $Name
	enemy_card_image_reference = $EnemyCardImage
	enemy_character_image_reference = $EnemyCharacterImage

func setup(card_id: String, attributes: Dictionary, card_scale: Vector2 = Vector2.ONE) -> void:
	attribut_card_id = card_id
	scale = card_scale
	
	attribute_health = attributes["health"]
	attribute_attack = attributes["attack"]
	
	health_reference.text = str(attribute_health)
	attack_reference.text = str(attribute_attack)
	name_reference.text = card_id.capitalize()
	
	enemy_card_image_reference.texture = Constants.ENEMY_CARD_TEMPLATE
	enemy_character_image_reference.texture = CardDatabase.get_enemy_card_portrait(card_id)
	
func get_width() -> float:
	return enemy_card_image_reference.get_rect().size.x * scale.x

func take_damage(damage: int) -> void:
	attribute_health -= damage
	
	if attribute_health <= 0:
		attribute_health = 0
		EventBus.enemy_is_dead.emit(self)
		
	health_reference.text = str(attribute_health)
