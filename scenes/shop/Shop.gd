extends Node2D

const SHOP_CARD_COUNT := 3

var card_scene: PackedScene = preload(Constants.CARD_SCENE_PATH)
var cards_to_add_reference: HBoxContainer

func _ready() -> void:
	cards_to_add_reference = $CardsToAdd
	
	_fill_cards_to_add()

func _fill_cards_to_add() -> void:
	for child: Node in cards_to_add_reference.get_children():
		child.queue_free()

	var card_ids_pool: Array[String] = CardDatabase.reward_pool_ids().duplicate()

	for i: int in SHOP_CARD_COUNT:
		var card_id: String = CardDatabase.draw_reward_id(card_ids_pool, Constants.LevelType.SHOP)
		
		if card_id.is_empty():
			return
			
		_add_card_choice(CardInstance.new(card_id))
		card_ids_pool.erase(card_id)
		
		if card_ids_pool.is_empty():
			return

func _add_card_choice(card_instance: CardInstance) -> void:
	var card_size: Vector2 = Vector2(Constants.CARD_WIDTH, Constants.CARD_HEIGHT)

	var slot := Button.new()
	slot.flat = true
	slot.custom_minimum_size = card_size
	slot.pressed.connect(_on_card_chosen.bind(card_instance))
	cards_to_add_reference.add_child(slot)

	var card: Card = card_scene.instantiate()
	slot.add_child(card)  # add first so Card._ready() grabs its node references
	card.setup(card_instance, Constants.CARD_SCALE_DEFAULT)
	card.position = card_size / 2.0  # the card's origin is its center

func _on_card_chosen(card_instance: CardInstance) -> void:
	GameState.all_player_cards.append(card_instance)
	
	for slot: Node in cards_to_add_reference.get_children():
		(slot as Button).disabled = true
	
	SceneManager.go_to_map()

func _on_skip_choose_pressed() -> void:
	SceneManager.go_to_map()
