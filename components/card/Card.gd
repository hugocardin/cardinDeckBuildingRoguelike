class_name Card

extends Node2D

var starting_position: Vector2
var attribut_attack: int
var attribut_shield: int

var instance: CardInstance

@onready var card_image_reference: Sprite2D = $CardImage
@onready var character_image_reference: Sprite2D = $CharacterImage
@onready var gem_image_reference: Sprite2D = $GemImage
@onready var attack_text_reference: RichTextLabel = $Attack
@onready var shield_text_reference: RichTextLabel = $Shield
@onready var name_reference: FitRichTextLabel = $Name

func setup(card_instance: CardInstance, card_scale: Vector2 = Vector2.ONE) -> void:
	instance = card_instance
	scale = card_scale
	var rarity: Constants.CardRarity = instance.get_rarity()
	
	card_image_reference.texture = Constants.CARD_FRAMES[rarity]
	
	# Note : the cards which had been generated because today are hidding the frame because it takes 
	# the whole space, fine for now, in the future they will all get removed and the new one fit 
	# correctly as been png with transparent background.
	character_image_reference.texture = CardDatabase.get_player_card_portrait(instance.card_id)
	
	gem_image_reference.texture = Constants.CARD_GEMS[rarity]
	
	refresh()
	
func refresh() -> void:
	if instance == null:
		return
	
	attribut_attack = instance.get_attack()
	attribut_shield = instance.get_shield()
	
	attack_text_reference.text = str(attribut_attack)
	shield_text_reference.text = str(attribut_shield)
	name_reference.set_fitted_text(instance.display_name())
	
func on_tap() -> void:
	# TODO to implement later
	print("Tapped on player card: " + instance.card_id)
