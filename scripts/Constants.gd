class_name Constants
extends RefCounted

const CARD_DEFAULT_MOVE_DURATION := 0.1
const CARD_SCENE_PATH := "res://components/card/Card.tscn"
const CARD_SCALE_DEFAULT := Vector2(0.3, 0.3)
const CARD_NATIVE_SIZE := Vector2(768, 1168)
const CARD_HEIGHT := CARD_NATIVE_SIZE[1] * CARD_SCALE_DEFAULT.y
const CARD_WIDTH := CARD_NATIVE_SIZE[0] * CARD_SCALE_DEFAULT.x
const CARD_INFINITE_UPGRADES := -1

const DECK_DRAW_DURATION := 0.5
const DECK_POSITION := Vector2(150, 550)

const DISCARD_POSITION := Vector2(150, 550)

const ENEMIES_HAND_TOP_MARGIN := 20
const ENEMIES_Y := ENEMIES_HAND_TOP_MARGIN + CARD_HEIGHT / 2.0
const MAX_NORMAL_ENEMIES := 3

const ENEMY_CARD_SCENE_PATH := "res://components/enemy_card/EnemyCard.tscn"
const BATTLE_SCENE_PATH := "res://scenes/battle/Battle.tscn"

const PLAYER_CARD_COUNT := 4
const PLAYER_HAND_BOTTOM_MARGIN := 20

const MAP_ROWS := 8
const MAP_COLUMNS := 4
const MAP_NODE_SIZE := Vector2(128, 128)
const MAP_MIN_NODE_SPACING := 250
const MAP_NODE_CHANCE := 0.65
const PATH_PATH := "res://assets/path.png"

enum LevelType { NORMAL_BATTLE, ELITE_BATTLE, WORLD_BOSS_BATTLE, SHOP }

const LEVEL_ICONS : Dictionary[LevelType, String]= {
	LevelType.NORMAL_BATTLE: "res://assets/nodes/normal.png",
	LevelType.ELITE_BATTLE: "res://assets/nodes/elite.png",
	LevelType.WORLD_BOSS_BATTLE: "res://assets/nodes/boss.png",
	LevelType.SHOP: "res://assets/nodes/shop.png"
}

const MAP_BACKGROUNDS: Array[String] = [
	"res://assets/backgrounds/cloud_castle.jpg",
	"res://assets/backgrounds/dinosaur_meadow.jpg",
	"res://assets/backgrounds/enchanted_forest.jpg",
	"res://assets/backgrounds/floating_candy_islands.jpg",
	"res://assets/backgrounds/flower_power_garden.jpg",
	"res://assets/backgrounds/magic_library_sky.jpg",
	"res://assets/backgrounds/snowy_animal_village.jpg",
	"res://assets/backgrounds/space_playground.jpg",
	"res://assets/backgrounds/sunny_beach.jpg",
	"res://assets/backgrounds/underwater_reef.jpg"
]

enum CardRarity { COMMON, UNCOMMON, RARE, LEGENDARY }

const CARD_RARITY_WEIGHTS: Dictionary[LevelType, Dictionary] = {
	LevelType.NORMAL_BATTLE: {
		CardRarity.COMMON: 60, CardRarity.UNCOMMON: 25, CardRarity.RARE: 12, CardRarity.LEGENDARY: 3,
	},
	LevelType.ELITE_BATTLE: {
		CardRarity.COMMON: 20, CardRarity.UNCOMMON: 40, CardRarity.RARE: 30, CardRarity.LEGENDARY: 10,
	},
	LevelType.WORLD_BOSS_BATTLE: {
		CardRarity.LEGENDARY: 100,
	},
	LevelType.SHOP: {
		CardRarity.COMMON: 60, CardRarity.UNCOMMON: 25, CardRarity.RARE: 12, CardRarity.LEGENDARY: 3
	}
}

const CARD_UNLIMITED_COPIES := -1
