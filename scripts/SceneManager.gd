extends Node

func go_to_battle():
	get_tree().change_scene_to_file("res://scenes/battle/Battle.tscn")

func go_to_home():
	get_tree().change_scene_to_file("res://scenes/home/Home.tscn")
	
func go_to_player_dead():
	get_tree().change_scene_to_file("res://scenes/player_is_dead/PlayerIsDead.tscn")
	
func go_to_battle_victory():
	get_tree().change_scene_to_file("res://scenes/battle_victory/BattleVictory.tscn")
