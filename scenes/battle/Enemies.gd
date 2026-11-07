class_name Enemies

extends Node2D

var enemy_cards
var center_screen_x
var card_manager_reference
var enemies_y

func _ready() -> void:
	center_screen_x = get_viewport().get_visible_rect().size.x / 2.0
	enemies_y = Constants.ENEMIES_HAND_TOP_MARGIN + Constants.CARD_HEIGHT / 2.0
	enemy_cards = []
	
	card_manager_reference = $"../CardManager"
	
	EventBus.enemy_is_dead.connect(_on_enemy_is_dead)
	
func setup(enemies):
	for enemy_card_name in enemies:
		var enemy_card_scene = preload(Constants.ENEMY_CARD_SCENE_PATH)
		var new_enemy_card = enemy_card_scene.instantiate()
		
		card_manager_reference.add_child(new_enemy_card)
		
		new_enemy_card.setup(enemy_card_name, CardDatabase.ENEMY_CARDS[enemy_card_name], Constants.CARD_SCALE_DEFAULT)
		add_enemy_card(new_enemy_card)

func add_enemy_card(enemy_card: EnemyCard):
	enemy_cards.insert(0, enemy_card)
	update_hand_positions()
		
func _on_enemy_is_dead(enemy_card: EnemyCard):
	if enemy_card in enemy_cards:
		enemy_cards.erase(enemy_card)
		update_hand_positions()
		card_manager_reference.remove_child(enemy_card)
		
	if enemy_cards.size() == 0:
		SceneManager.go_to_battle_victory()

func update_hand_positions():
	for i in range(enemy_cards.size()):
		var enemy_card = enemy_cards[i]
		var x = calculate_card_position(i)
		var target = Vector2(x, enemies_y)
		animate_card_to_position(enemy_card, target, Constants.CARD_DEFAULT_MOVE_DURATION)

func calculate_card_position(index: int) -> float:
	var count = enemy_cards.size()
	var screen_width = center_screen_x * 2.0
	
	var total_cards_width = count * Constants.CARD_WIDTH
	var total_spacing = screen_width - total_cards_width
	var gap = total_spacing / (count + 1)
	
	return gap + index * (Constants.CARD_WIDTH + gap) + Constants.CARD_WIDTH / 2.0
	
func get_card_width() -> float:
	if enemy_cards.is_empty():
		return 0
	return enemy_cards[0].get_node("EnemyCardImage").get_rect().size.x * enemy_cards[0].scale.x

func animate_card_to_position(card: Node2D, target_position: Vector2, duration: float):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "position", target_position, duration)
