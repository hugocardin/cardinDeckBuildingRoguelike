class_name Enemies

extends Node2D

var enemy_cards: Array[EnemyCard]
var center_screen_x: float

var card_manager_reference: CardManager

func _ready() -> void:
	center_screen_x = get_viewport().get_visible_rect().size.x / 2.0
	enemy_cards = []
	
	card_manager_reference = $"../CardManager"
	
	EventBus.enemy_is_dead.connect(_on_enemy_is_dead)
	
func setup(enemies: Array[String]) -> void:
	for enemy_card_name: String in enemies:
		var new_enemy_card: EnemyCard = load(Constants.ENEMY_CARD_SCENE_PATH).instantiate()
		
		card_manager_reference.add_child(new_enemy_card)
		
		new_enemy_card.setup(enemy_card_name, 
							CardDatabase.ENEMY_CARDS[GameState.current_node.type][enemy_card_name], 
							Constants.CARD_SCALE_DEFAULT)
		add_enemy_card(new_enemy_card)

func add_enemy_card(enemy_card: EnemyCard) -> void:
	enemy_cards.insert(0, enemy_card)
	update_hand_positions()
		
func _on_enemy_is_dead(enemy_card: EnemyCard) -> void:
	if enemy_card in enemy_cards:
		enemy_cards.erase(enemy_card)
		enemy_card.queue_free()
		update_hand_positions()
		
	if enemy_cards.size() == 0:
		SceneManager.go_to_battle_victory()

func update_hand_positions() -> void:
	var enemies_count: int = enemy_cards.size()
	
	for i: int in range(enemies_count):
		var enemy_card: EnemyCard = enemy_cards[i]
		var x: float = calculate_card_position(i, enemies_count)
		var target: Vector2 = Vector2(x, Constants.ENEMIES_Y)
		animate_card_to_position(enemy_card, target, Constants.CARD_DEFAULT_MOVE_DURATION)

func calculate_card_position(index: int, total_count: int) -> float:
	var screen_width = center_screen_x * 2.0
	var total_cards_width = total_count * Constants.CARD_WIDTH
	var total_spacing = screen_width - total_cards_width
	var gap = total_spacing / (total_count + 1)
	
	return gap + index * (Constants.CARD_WIDTH + gap) + Constants.CARD_WIDTH / 2.0
	
func animate_card_to_position(card: Node2D, target_position: Vector2, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "position", target_position, duration)
