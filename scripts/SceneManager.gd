extends Node

func _ready() -> void:
	EventBus.node_selected.connect(_on_node_selected)
	EventBus.character_selected.connect(_on_character_selected)

func go_to_home():
	get_tree().change_scene_to_file("res://scenes/home/Home.tscn")

func go_to_character_selection():
	get_tree().change_scene_to_file("res://scenes/character_selection/CharacterSelection.tscn")

func go_to_player_dead():
	get_tree().change_scene_to_file("res://scenes/player_is_dead/PlayerIsDead.tscn")

func go_to_map():
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")

func go_to_battle_victory():
	GameState.current_map_row += 1
	
	if GameState.current_map_row <= Constants.MAP_ROWS:
		get_tree().change_scene_to_file("res://scenes/battle_victory/BattleVictory.tscn")
	else:
		GameState.reset()
		go_to_home()
	
func _on_character_selected(character_name: String):
	GameState.set_character(character_name)
	
	go_to_map()

func _on_node_selected(node: MapNode):
	if node.type == Constants.LevelType.SHOP:
		print("Shoppy time")
	else:
		GameState.set_enemies(_get_enemies_by_tier(node.type))
		GameState.current_battle_type = node.type
		get_tree().change_scene_to_file("res://scenes/battle/Battle.tscn")

func _get_enemies_by_tier(tier: Constants.LevelType) -> Array[String]:
	var enemies: Dictionary = CardDatabase.ENEMY_CARDS[tier]
	var keys := enemies.keys()
	var result: Array[String] = []
	var count: int = 1
	
	if tier == Constants.LevelType.NORMAL_BATTLE:
		count = randi_range(1, 3)
	
	for i in count:
		var key = keys[randi() % keys.size()]
		result.append(key)
	return result
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
