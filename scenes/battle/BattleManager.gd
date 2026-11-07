extends Node

var battle_timer

var enemies_reference
var player_reference
var deck_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.wait_time = 1
	battle_timer.one_shot = true
	
	enemies_reference = $"../Enemies"
	player_reference = $"../Player"
	deck_reference = $"../Deck"
	
	deck_reference.setup(Constants.DECK_DRAW_INITIAL_CARDS.duplicate())
	enemies_reference.setup(Constants.ENEMIES_INITIAL_CARDS.duplicate())
	
	EventBus.player_turn_started.emit()

func _on_end_turn_button_pressed() -> void:
	EventBus.player_turn_ended.emit()
	EventBus.enemy_turn_started.emit()
	
	opponent_turn()	
	
	EventBus.enemy_turn_ended.emit()
	EventBus.player_turn_started.emit()

func opponent_turn():
	for enemy_card in enemies_reference.enemy_cards:
		player_reference.take_damage(enemy_card.attribute_attack)
		battle_timer.start()
		await battle_timer.timeout
		
		if player_reference.is_dead():
			SceneManager.go_to_player_dead()
			return
