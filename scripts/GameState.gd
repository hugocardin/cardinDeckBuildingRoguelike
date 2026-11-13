extends Node

var selected_character_name: String
var current_health: int
var full_health: int
var maximum_action: int
var all_player_cards: Array[CardInstance]
var current_enemies: Array[String]
var current_map_nodes: Array[MapNode]
var map_background_index: int
var current_node: MapNode

func _ready() -> void:
	reset()

func set_character(character_name: String) -> void:
	var player_character: Dictionary = CharacterDatabase.CHARACTERS[character_name]
	
	selected_character_name = character_name
	full_health = player_character["health"]
	current_health = full_health
	
	all_player_cards = []
	for card_id: String in player_character["starting_cards"]:
		all_player_cards.append(CardInstance.new(card_id))

func set_enemies(enemies: Array[String]) -> void:
	current_enemies = enemies.duplicate()

func clear_battle() -> void:
	current_enemies = []
	
func is_player_dead() -> bool:
	return current_health <= 0
	
func reset() -> void:
	selected_character_name = ""
	current_health = 0
	full_health = 0
	maximum_action = 3
	all_player_cards = []
	current_enemies = []
	
	reset_for_new_world()

func reset_for_new_world() -> void:
	current_map_nodes = []
	current_node = null
	map_background_index = 0
