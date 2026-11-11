extends Node

var battle_timer

var enemies_reference
var player_reference
var deck_reference
var end_button_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $BattleTimer
	battle_timer.wait_time = 1
	battle_timer.one_shot = true
	
	enemies_reference = $Enemies
	player_reference = $Player
	deck_reference = $Deck
	end_button_reference = $EndTurnButton
	
	initialise_cards()
	
func initialise_cards():
	player_reference.setup()
	
	var deck_cards = GameState.all_player_cards.duplicate()
	deck_cards.shuffle()
	deck_reference.setup(deck_cards)
	
	var enemy_cards: Array[String] = GameState.current_enemies
	enemies_reference.setup(enemy_cards)
	
	EventBus.player_turn_started.emit()

func _on_end_turn_button_pressed() -> void:
	end_button_reference.text = "Enemy turn"
	end_button_reference.disabled = true
	EventBus.player_turn_ended.emit()
	EventBus.enemy_turn_started.emit()
	
	await opponent_turn()	
	
	EventBus.enemy_turn_ended.emit()
	EventBus.player_turn_started.emit()
	end_button_reference.text = "End turn"
	end_button_reference.disabled = false

func opponent_turn() -> void:
	for enemy_card in enemies_reference.enemy_cards.duplicate():
		player_reference.take_damage(enemy_card.attribute_attack)
		battle_timer.start()
		await battle_timer.timeout
		
		if GameState.is_player_dead():
			SceneManager.go_to_player_dead()
			return
