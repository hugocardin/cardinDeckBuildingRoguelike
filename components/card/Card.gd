class_name Card

extends Node2D

var starting_position: Vector2
var attribut_attack: int
var attribut_shield: int

var instance: CardInstance

var attack_text_reference: RichTextLabel
var shield_text_reference: RichTextLabel
var card_image_reference: Sprite2D
var name_reference: RichTextLabel
var rarity_reference: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_text_reference = $Attack
	shield_text_reference = $Shield
	card_image_reference = $CardImage
	name_reference = $Name
	rarity_reference = $Rarity

func setup(card_instance: CardInstance, card_scale: Vector2 = Vector2.ONE) -> void:
	instance = card_instance
	scale = card_scale
	
	var image_path: String = "res://assets/cards/" + instance.card_id + ".jpg"
	card_image_reference.texture = load(image_path)
	
	refresh()
	
func refresh() -> void:
	if instance == null:
		return
		
	attribut_attack = instance.get_attack()
	attribut_shield = instance.get_shield()
	
	attack_text_reference.text = str(attribut_attack)
	shield_text_reference.text = str(attribut_shield)
	name_reference.text = instance.display_name()
	rarity_reference.text = instance.display_rarity()
