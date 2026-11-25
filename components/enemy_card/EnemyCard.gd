class_name EnemyCard

extends Node2D

var attribut_card_id: String
var attribute_health: int
var attribute_attack: int

@onready var health_reference: RichTextLabel = $Health
@onready var attack_reference: RichTextLabel = $Attack
@onready var name_reference: FitRichTextLabel = $Name
@onready var enemy_card_image_reference: Sprite2D = $EnemyCardImage
@onready var enemy_character_image_reference: Sprite2D = $EnemyCharacterImage

func setup(card_id: String, attributes: Dictionary, card_scale: Vector2 = Vector2.ONE) -> void:
	attribut_card_id = card_id
	scale = card_scale
	
	attribute_health = attributes["health"]
	attribute_attack = attributes["attack"]
	
	health_reference.text = str(attribute_health)
	attack_reference.text = str(attribute_attack)
	# TODO use translations
	name_reference.set_fitted_text(card_id.capitalize())
	
	enemy_character_image_reference.texture = CardDatabase.get_enemy_card_portrait(card_id)
	
func get_width() -> float:
	return enemy_card_image_reference.get_rect().size.x * scale.x

func take_damage(damage: int) -> void:
	attribute_health -= damage
	
	if attribute_health <= 0:
		attribute_health = 0
		EventBus.enemy_is_dead.emit(self)
		
	health_reference.text = str(attribute_health)

func on_tap() -> void:
	# TODO implement later
	print("Tapped on enemy: " + attribut_card_id)
