class_name Card

extends Node2D

var starting_position: Vector2
var attribut_name: String
var attribut_attack: int
var attribut_shield: int

var instance: CardInstance

var attack_text_reference: RichTextLabel
var shield_text_reference: RichTextLabel
var card_image_reference: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_text_reference = $Attack
	shield_text_reference = $Shield
	card_image_reference = $CardImage

func _on_area_2d_mouse_entered() -> void:
	EventBus.card_hovered.emit(self)

func _on_area_2d_mouse_exited() -> void:
	EventBus.card_hovered_off.emit(self)
	
func setup(card_instance: CardInstance, card_scale: Vector2 = Vector2.ONE) -> void:
	instance = card_instance
	attribut_name = instance.display_name()
	scale = card_scale
	
	attribut_attack = instance.get_stat("attack")
	attribut_shield = instance.get_stat("shield")
	
	attack_text_reference.text = str(attribut_attack)
	shield_text_reference.text = str(attribut_shield)
	
	var image_path: String = "res://assets/cards/" + instance.card_id + ".jpg"
	card_image_reference.texture = load(image_path)
