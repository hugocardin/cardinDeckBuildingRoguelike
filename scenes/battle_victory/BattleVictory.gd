extends Node2D

var was_boss_battle: bool

var next_battle_reference: Button
var after_boss_go_home_reference: Button

func _ready() -> void:
	was_boss_battle = GameState.current_node != null and GameState.current_node.type == Constants.LevelType.WORLD_BOSS_BATTLE
	
	next_battle_reference = $NextBattleButton
	next_battle_reference.text = "Next World" if was_boss_battle else "Next Battle"
	
	after_boss_go_home_reference = $AfterBossGoHome
	after_boss_go_home_reference.visible = was_boss_battle

func _on_after_boss_go_home_pressed() -> void:
	SceneManager.go_to_home()
	
func _on_next_battle_button_pressed() -> void:
	if was_boss_battle:
		GameState.reset_for_new_world()
	
	_upgrade_random_card()
	
	SceneManager.go_to_map()

func _upgrade_random_card() -> void:
	var upgradable: Array[CardInstance] = GameState.all_player_cards.filter(
		func(card: CardInstance) -> bool: return card.can_upgrade()
	)
	if upgradable.is_empty():
		return

	var card_instance: CardInstance = upgradable.pick_random()
	card_instance.upgrade()
