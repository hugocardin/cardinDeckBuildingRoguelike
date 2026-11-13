extends Node

func _ready() -> void:
	EventBus.node_selected.connect(_on_node_selected)
	EventBus.character_selected.connect(_on_character_selected)

func go_to_home() -> void:
	get_tree().change_scene_to_file("res://scenes/home/Home.tscn")

func go_to_character_selection() -> void:
	get_tree().change_scene_to_file("res://scenes/character_selection/CharacterSelection.tscn")

func go_to_player_dead() -> void:
	get_tree().change_scene_to_file("res://scenes/player_is_dead/PlayerIsDead.tscn")

func go_to_map() -> void:
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")

func go_to_shop() -> void:
	get_tree().change_scene_to_file("res://scenes/shop/Shop.tscn")
	
func go_to_battle_victory() -> void:
	GameState.set_enemies([])
	
	get_tree().change_scene_to_file("res://scenes/battle_victory/BattleVictory.tscn")
	
func _on_character_selected(character_name: String) -> void:
	GameState.reset()
	GameState.set_character(character_name)
	
	go_to_map()

func _on_node_selected(node: MapNode) -> void:
	GameState.current_node = node
	
	if node.type == Constants.LevelType.SHOP:
		go_to_shop()
	else:
		GameState.set_enemies(_get_enemies_by_tier(node.type))
		get_tree().change_scene_to_file(Constants.BATTLE_SCENE_PATH)

func _get_enemies_by_tier(tier: Constants.LevelType) -> Array[String]:
	var enemies: Dictionary = CardDatabase.ENEMY_CARDS[tier]
	var keys: Array = enemies.keys()
	var result: Array[String] = []
	var count: int = 1
	
	if tier == Constants.LevelType.NORMAL_BATTLE:
		count = randi_range(1, Constants.MAX_NORMAL_ENEMIES)
	
	for i in count:
		var key: String = keys[randi() % keys.size()]
		result.append(key)
	return result
