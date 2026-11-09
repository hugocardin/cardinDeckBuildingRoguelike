extends Node

var selected_character_name
var current_health
var full_health
var maximum_action
var all_player_cards
var current_enemies: Array[String]
var current_map_nodes: Array[MapNode]
var current_node: MapNode = null

func _ready() -> void:
	reset()

func set_character(character_name):
	var player_character = CharacterDatabase.CHARACTERS[character_name]
	
	selected_character_name = character_name
	full_health = player_character["health"]
	current_health = full_health
	all_player_cards = player_character["starting_cards"].duplicate()

func set_enemies(enemies: Array[String]):
	current_enemies = enemies.duplicate()

func clear_battle():
	current_enemies = []
	
func is_player_dead() -> bool:
	return current_health <= 0
	
func reset() -> void:
	selected_character_name = null
	current_health = null
	full_health = null
	maximum_action = 3
	all_player_cards = []
	current_enemies = []
	current_map_nodes= []
	current_node = null
