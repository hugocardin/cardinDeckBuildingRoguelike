class_name Deck

extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_DURATION = 0.5

var player_deck = ["knight", "knight", "knight", "demon", "archer"]

var input_manager_reference
var card_manager_reference
var player_hand_reference
var rich_text_reference
var card_database_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_manager_reference = $"../InputManager"
	input_manager_reference.connect("left_mouse_button_pressed_on_deck", draw_card)
	
	card_manager_reference = $"../CardManager"
	player_hand_reference = $"../PlayerHand"
	card_database_reference = preload("res://scripts/CardDatabase.gd")
	
	rich_text_reference = $RichTextLabel
	_set_card_count()
	
	player_deck.shuffle()

func draw_card():
	var card_name = player_deck[0]
	player_deck.erase(card_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		rich_text_reference.visible = false
	
	_set_card_count()
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	card_manager_reference.add_child(new_card)
	new_card.setup(card_name, card_database_reference.CARDS[card_name])
	player_hand_reference.add_card_to_hand(new_card, CARD_DRAW_DURATION)
	
func _set_card_count():
	rich_text_reference.text = str(player_deck.size())
