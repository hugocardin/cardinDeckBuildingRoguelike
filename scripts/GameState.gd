extends Node

enum BATTLE_CURRENT_TURN {PLAYER, OPONNENT}

var selected_character_name: String
var current_health: int
var full_health: int
var maximum_action: int
var all_player_cards: Array[String]
var current_enemies: Array[String]
var current_map_nodes: Array[MapNode]
var map_background_index: int
var current_node: MapNode
var battle_current_turn: BATTLE_CURRENT_TURN

func _ready() -> void:
	reset()

func set_character(character_name: String) -> void:
	var player_character: Dictionary = CharacterDatabase.CHARACTERS[character_name]
	
	selected_character_name = character_name
	full_health = player_character["health"]
	current_health = full_health
	all_player_cards.assign(player_character["starting_cards"].duplicate())

func set_enemies(enemies: Array[String]) -> void:
	current_enemies = enemies.duplicate()

func clear_battle() -> void:
	current_enemies = []
	
func is_player_dead() -> bool:
	return current_health <= 0

func is_player_turn() -> bool:
	return battle_current_turn == BATTLE_CURRENT_TURN.PLAYER
	
func reset() -> void:
	selected_character_name = ""
	current_health = 0
	full_health = 0
	maximum_action = 3
	all_player_cards = []
	current_enemies = []
	current_map_nodes= []
	current_node = null
	battle_current_turn = BATTLE_CURRENT_TURN.PLAYER
	map_background_index = 0
