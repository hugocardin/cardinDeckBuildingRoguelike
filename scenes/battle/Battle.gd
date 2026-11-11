class_name Battle

extends Node

var battle_timer: Timer

enum BATTLE_CURRENT_TURN {PLAYER, OPONNENT}

var battle_current_turn: BATTLE_CURRENT_TURN
	
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
	
	_initialise_cards()
	
func _initialise_cards() -> void:
	battle_current_turn = BATTLE_CURRENT_TURN.PLAYER
	
	player_reference.setup()
	player_reference.player_turn_started()
	
	var deck_cards: Array[CardInstance] = []
	for card_instance: CardInstance in GameState.all_player_cards:
		deck_cards.append(card_instance.copy())
	
	deck_cards.shuffle()
	deck_reference.setup(deck_cards)
	deck_reference.refill_hand()
	
	var enemy_cards: Array[String] = GameState.current_enemies
	enemies_reference.setup(enemy_cards)
	
func is_player_turn() -> bool:
	return battle_current_turn == BATTLE_CURRENT_TURN.PLAYER

func _on_end_turn_button_pressed() -> void:
	end_button_reference.text = "Enemy turn"
	end_button_reference.disabled = true
	battle_current_turn = BATTLE_CURRENT_TURN.OPONNENT
	
	await opponent_turn()
	
	if !GameState.is_player_dead():
		end_button_reference.text = "End turn"
		end_button_reference.disabled = false
		battle_current_turn = BATTLE_CURRENT_TURN.PLAYER
		
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
