class_name CharacterDatabase
extends RefCounted

const CHARACTERS: Dictionary[String, Dictionary] = {
	"knight": {
		"health": 50,
		"starting_cards": ["berserker", "knight", "knight", "knight", "knight", "archer", "archer", "archer"]
	},
	"sorcerer": {
		"health": 35,
		"starting_cards": ["demon", "demon", "archer", "archer", "archer", "berserker", "knight", "knight"]
	},
}
