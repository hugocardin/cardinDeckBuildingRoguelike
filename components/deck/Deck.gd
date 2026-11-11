class_name Deck

extends Node2D

var player_deck: Array[String]

var card_count_reference: RichTextLabel

var card_manager_reference: CardManager
var player_hand_reference: PlayerHand
var discard_reference: Discard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.left_mouse_button_pressed_on_deck.connect(_on_left_mouse_button_pressed_on_deck)
	
	card_manager_reference = $"../CardManager"
	player_hand_reference = $"../PlayerHand"
	discard_reference = $"../Discard"
	card_count_reference = $CardCount

func setup(cards: Array[String]) -> void:
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
		
	var card_name: String = player_deck[0]
	player_deck.remove_at(0)
	
	_set_card_count_text()
	var new_card: Card = preload(Constants.CARD_SCENE_PATH).instantiate()
	
	card_manager_reference.add_child(new_card)
	new_card.global_position = Constants.DECK_POSITION
	
	new_card.setup(card_name, CardDatabase.CARDS[card_name], Constants.CARD_SCALE_DEFAULT)
	player_hand_reference.add_card_to_hand(new_card, Constants.DECK_DRAW_DURATION)

func _set_card_count_text() -> void:
	card_count_reference.text = str(player_deck.size())
	
func draw_initial_cards() -> void:
	for i: int in range(Constants.PLAYER_CARD_COUNT - player_hand_reference.cards.size()):
		draw_card()
		
func _on_left_mouse_button_pressed_on_deck() -> void:
	# TODO show the Draw's cards
	pass
