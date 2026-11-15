class_name Card

extends Node2D

var starting_position: Vector2
var attribut_attack: int
var attribut_shield: int

var instance: CardInstance

var card_image_reference: Sprite2D
var character_image_reference: Sprite2D
var gem_image_reference: Sprite2D
var attack_text_reference: RichTextLabel
var shield_text_reference: RichTextLabel
var name_reference: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_image_reference = $CardImage
	character_image_reference = $CharacterImage
	gem_image_reference = $GemImage
	attack_text_reference = $Attack
	shield_text_reference = $Shield
	name_reference = $Name

func setup(card_instance: CardInstance, card_scale: Vector2 = Vector2.ONE) -> void:
	instance = card_instance
	scale = card_scale
	
	var rarety_name: String = ""
	var card_rarety: Constants.CardRarity = instance.get_rarety()
	
	if card_rarety == Constants.CardRarity.EMERALD:
		rarety_name = "emerald"
	elif card_rarety == Constants.CardRarity.RUBY:
		rarety_name = "ruby"
	elif card_rarety == Constants.CardRarity.DIAMOND:
		rarety_name = "diamond"
	
	var card_image_path: String = "res://assets/cards/card_" + rarety_name + ".jpg"
	card_image_reference.texture = load(card_image_path)
	
	# Note : the cards which had been generated because today are hidding the frame because it takes 
	# the whole space, fine for now, in the future they will all get removed and the new one fit 
	# correctly as been png with transparent background.
	var character_image_path: String = "res://assets/player_cards/" + instance.card_id + ".png"
	character_image_reference.texture = load(character_image_path)
	
	var gem_image_path: String = "res://assets/cards/" + rarety_name + ".png"
	gem_image_reference.texture = load(gem_image_path)
	
	refresh()
	
func refresh() -> void:
	if instance == null:
		return
	
	attribut_attack = instance.get_attack()
	attribut_shield = instance.get_shield()
	
	attack_text_reference.text = str(attribut_attack)
	shield_text_reference.text = str(attribut_shield)
	name_reference.text = instance.display_name()
