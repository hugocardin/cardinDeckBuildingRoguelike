class_name CardDatabase
extends RefCounted

const CARDS: Dictionary[String, Dictionary] = {
	"knight": {
		"attack": 2,
		"shield": 6,
		"max_upgrades": 1,
		"upgrade": { "type": "flat", "shield": 3 }
	},
	"archer": {
		"attack": 7,
		"shield": 1,
		"max_upgrades": 1,
		"upgrade": { "type": "flat", "attack": 3 }
	},
	"demon": {
		"attack": 9,
		"shield": 9,
		"upgrade": { "type": "steps", "list": [{"attack": 10}, {"shield": 10}, {"attack": 10, "shield": 10}] }
	},
	"berserker": { 
		"attack": 11, 
		"shield": 0,
		"max_upgrades": Constants.CARD_INFINITE_UPGRADES,
		"upgrade": {"type": "escalating", "stat": "attack", "start": 1, "step": 1} 
	}
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
