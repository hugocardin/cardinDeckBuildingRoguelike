class_name CardDatabase
extends RefCounted

const CARDS: Dictionary[String, Dictionary] = {
	"knight": {
		"attack": 2,
		"shield": 6
	},
	"archer": {
		"attack": 7,
		"shield": 1
	},
	"demon": {
		"attack": 9,
		"shield": 9
	}
}

const ENEMY_CARDS: Dictionary[Constants.LevelType, Dictionary] = {
	Constants.LevelType.NORMAL_BATTLE: {
		"orc": {
			"attack": 3,
			"health": 1 #20
		},
		"wraithvine": {
			"attack": 9,
			"health": 1 #15
		},
		"gobelin": {
			"attack": 3,
			"health": 1 #10
		},
		"skeleton": {
			"attack": 5,
			"health": 1 #17
		},
		"wolf": {
			"attack": 10,
			"health": 1 #13
		}
	},
	Constants.LevelType.ELITE_BATTLE : {
		"armored_orc": {
			"attack": 10,
			"health": 1 #32
		},
		"dark_knight": {
			"attack": 15,
			"health": 1 #27
		},
		"corrupted_druid": {
			"attack": 13,
			"health": 1 #30
		}
	},
	Constants.LevelType.WORLD_BOSS_BATTLE: {
		"dragon": {
			"attack": 17,
			"health": 1 #150
		},
		"lich_king": {
			"attack": 20,
			"health": 1 #110
		}
	}
}
