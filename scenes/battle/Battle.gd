extends Node

var battle_timer: Timer

var enemies_reference: Enemies
var player_reference: Player
var deck_reference: Deck
var end_button_reference: Button

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
	
func initialise_cards() -> void:
	player_reference.setup()
	player_reference.player_turn_started()
	
	var deck_cards: Array[String] = GameState.all_player_cards.duplicate()
	deck_cards.shuffle()
	deck_reference.setup(deck_cards)
	deck_reference.draw_initial_cards()
	
	var enemy_cards: Array[String] = GameState.current_enemies
	enemies_reference.setup(enemy_cards)
	

func _on_end_turn_button_pressed() -> void:
	end_button_reference.text = "Enemy turn"
	end_button_reference.disabled = true
	GameState.battle_current_turn = GameState.BATTLE_CURRENT_TURN.OPONNENT
	
	await opponent_turn()
	
	if !GameState.is_player_dead():
		end_button_reference.text = "End turn"
		end_button_reference.disabled = false
		GameState.battle_current_turn = GameState.BATTLE_CURRENT_TURN.PLAYER
		
		player_reference.player_turn_started()

func opponent_turn() -> void:
	for enemy_card: EnemyCard in enemies_reference.enemy_cards.duplicate():
		if not is_instance_valid(enemy_card) or enemy_card not in enemies_reference.enemy_cards:
			continue
		
		player_reference.take_damage(enemy_card.attribute_attack)
		battle_timer.start()
		await battle_timer.timeout
		
		if GameState.is_player_dead():
			SceneManager.go_to_player_dead()
			return
