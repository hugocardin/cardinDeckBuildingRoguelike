class_name CardDatabase
extends RefCounted

const CARDS: Dictionary[String, Dictionary] = {
	"knight": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 2,
		"shield": 6,
		"max_upgrades": 1,
		"upgrade": { "type": "flat", "shield": 3 }
	},
	"archer": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 7,
		"shield": 1,
		"max_upgrades": 1,
		"upgrade": { "type": "flat", "attack": 3 }
	},
	"demon": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 9,
		"shield": 9,
		"upgrade": { "type": "steps", "list": [{"attack": 10}, {"shield": 10}, {"attack": 10, "shield": 10}] }
	},
	"berserker": { 
		"rarity": Constants.CardRarity.UNCOMMON,
		"attack": 11, 
		"shield": 0,
		"max_upgrades": Constants.CARD_INFINITE_UPGRADES,
		"upgrade": {"type": "escalating", "stat": "attack", "start": 1, "step": 1} 
	},
	"mage": {
		"rarity": Constants.CardRarity.RARE,
		"attack": 8,
		"shield": 3,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "attack": 3 }
	},
	"assassin": {
		"rarity": Constants.CardRarity.RARE,
		"attack": 10,
		"shield": 0,
		"upgrade": { "type": "steps", "list": [{"attack": 4}, {"attack": 6, "shield": 2}] }
	},
	"golem": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 1,
		"shield": 10,
		"max_upgrades": Constants.CARD_INFINITE_UPGRADES,
		"upgrade": { "type": "escalating", "stat": "shield", "start": 2, "step": 1 }
	},
	"cleric": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 3,
		"shield": 5,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "shield": 2 }
	},
	"monk": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 5,
		"shield": 3,
		"max_upgrades": 3,
		"upgrade": { "type": "escalating", "stat": "attack", "start": 2, "step": 1 }
	},
	"pirate": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 6,
		"shield": 2,
		"upgrade": { "type": "steps", "list": [{"attack": 3}, {"attack": 2, "shield": 1}] }
	},
	"dwarf": {
		"rarity": Constants.CardRarity.COMMON,
		"attack": 4,
		"shield": 5,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "shield": 2 }
	},
	"shaman": {
		"rarity": Constants.CardRarity.UNCOMMON,
		"attack": 6,
		"shield": 4,
		"upgrade": { "type": "steps", "list": [{"attack": 2, "shield": 1}, {"attack": 3, "shield": 1}] }
	},
	"frost_witch": {
		"rarity": Constants.CardRarity.UNCOMMON,
		"attack": 8,
		"shield": 2,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "attack": 3 }
	},
	"dryad": {
		"rarity": Constants.CardRarity.UNCOMMON,
		"attack": 2,
		"shield": 8,
		"max_upgrades": 3,
		"upgrade": { "type": "escalating", "stat": "shield", "start": 2, "step": 1 }
	},
	"necromancer": {
		"rarity": Constants.CardRarity.RARE,
		"max_copies": 1,
		"attack": 9,
		"shield": 4,
		"upgrade": { "type": "steps", "list": [{"attack": 3, "shield": 1}, {"attack": 4, "shield": 2}] }
	},
	"minotaur": {
		"rarity": Constants.CardRarity.RARE,
		"attack": 10,
		"shield": 5,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "attack": 3, "shield": 1 }
	},
	"phoenix": {
		"rarity": Constants.CardRarity.RARE,
		"max_copies": 1,
		"attack": 12,
		"shield": 8,
		"max_upgrades": 2,
		"upgrade": { "type": "flat", "attack": 3, "shield": 3 }
	},
}

const ENEMY_CARDS: Dictionary[Constants.LevelType, Dictionary] = {
	Constants.LevelType.NORMAL_BATTLE: {
		"orc": {
			"attack": 3,
			"health": 20
		},
		"wraithvine": {
			"attack": 9,
			"health": 15
		},
		"gobelin": {
			"attack": 3,
			"health": 10
		},
		"skeleton": {
			"attack": 5,
			"health": 17
		},
		"wolf": {
			"attack": 10,
			"health": 13
		}
	},
	Constants.LevelType.ELITE_BATTLE : {
		"armored_orc": {
			"attack": 10,
			"health": 32
		},
		"dark_knight": {
			"attack": 15,
			"health": 27
		},
		"corrupted_druid": {
			"attack": 13,
			"health": 30
		}
	},
	Constants.LevelType.WORLD_BOSS_BATTLE: {
		"dragon": {
			"attack": 17,
			"health": 150
		},
		"lich_king": {
			"attack": 20,
			"health": 110
		}
	}
}

static func reward_pool_ids() -> Array[String]:
	var starters: Dictionary[String, bool] = {}
	for character: Dictionary in CharacterDatabase.CHARACTERS.values():
		for card_id: String in character["starting_cards"]:
			starters[card_id] = true

	var result: Array[String] = []
	for card_id: String in CARDS.keys():
		if not starters.has(card_id) and not _reached_max_copies(card_id):
			result.append(card_id)
	return result

static func _reached_max_copies(card_id: String) -> bool:
	var max_copies: int = CARDS[card_id].get("max_copies", Constants.CARD_UNLIMITED_COPIES)
	if max_copies == Constants.CARD_UNLIMITED_COPIES:
		return false
	var owned := 0
	for card: CardInstance in GameState.all_player_cards:
		if card.card_id == card_id:
			owned += 1
	return owned >= max_copies

static func draw_reward_id(pool: Array[String], source: Constants.LevelType) -> String:
	var weights: Dictionary = Constants.CARD_RARITY_WEIGHTS[source]

	var by_rarity: Dictionary[Constants.CardRarity, Array] = {}
	for card_id: String in pool:
		var card_id_rarity: Constants.CardRarity = CARDS[card_id].get("rarity", Constants.CardRarity.COMMON)
		if weights.get(card_id_rarity, 0) <= 0:
			continue
		if not by_rarity.has(card_id_rarity):
			by_rarity[card_id_rarity] = []
		by_rarity[card_id_rarity].append(card_id)

	if by_rarity.is_empty():
		return ""

	var rarity := _roll_rarity(by_rarity.keys(), weights)
	return by_rarity[rarity].pick_random()

static func _roll_rarity(available: Array, weights: Dictionary) -> Constants.CardRarity:
	var total := 0
	for rarity: Constants.CardRarity in available:
		total += weights[rarity]

	var roll := randi_range(1, total)
	for rarity: Constants.CardRarity in available:
		roll -= weights[rarity]
		if roll <= 0:
			return rarity
	
	return available.back()
