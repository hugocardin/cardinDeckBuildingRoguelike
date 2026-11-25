class_name Deck

extends Node2D

var player_deck: Array[CardInstance]

@onready var card_count_reference: RichTextLabel = $CardCount
@onready var card_manager_reference: CardManager = $"../CardManager"
@onready var player_hand_reference: PlayerHand = $"../PlayerHand"
@onready var discard_reference: Discard = $"../Discard"

const CARD_SCENE: PackedScene = preload(Constants.CARD_SCENE_PATH)

func setup(cards: Array[CardInstance]) -> void:
	player_deck = cards
	_set_card_count_text()

func draw_card() -> void:
	if player_hand_reference.cards.size() >= Constants.PLAYER_CARD_COUNT:
		return
		
	if player_deck.size() == 0:
		player_deck = discard_reference.empty_discard()
		player_deck.shuffle()
	
	# If no card in the discard, none will be added into the player's decks, can't draw
	if player_deck.size() == 0:
		return
		
	var card_instance: CardInstance = player_deck[0]
	player_deck.remove_at(0)
	
	_set_card_count_text()
	var new_card: Card = CARD_SCENE.instantiate()
	
	card_manager_reference.add_child(new_card)
	new_card.global_position = global_position
	
	new_card.setup(card_instance, Constants.CARD_SCALE_DEFAULT)
	player_hand_reference.add_card_to_hand(new_card, Constants.DECK_DRAW_DURATION)

func _set_card_count_text() -> void:
	card_count_reference.text = str(player_deck.size())
	
func refill_hand() -> void:
	for i: int in range(Constants.PLAYER_CARD_COUNT - player_hand_reference.cards.size()):
		draw_card()
		
func on_tap() -> void:
	# TODO show the Draw's cards
	print("Tapped on Deck")
