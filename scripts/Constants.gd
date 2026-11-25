class_name Constants
extends RefCounted

const CARD_DEFAULT_MOVE_DURATION := 0.1
const CARD_SCALE_DEFAULT := Vector2(0.3, 0.3)
const CARD_NATIVE_SIZE := Vector2(768, 1168)
const CARD_HEIGHT := CARD_NATIVE_SIZE[1] * CARD_SCALE_DEFAULT.y
const CARD_WIDTH := CARD_NATIVE_SIZE[0] * CARD_SCALE_DEFAULT.x
const CARD_INFINITE_UPGRADES := -1

const DECK_DRAW_DURATION := 0.5

const ENEMIES_HAND_TOP_MARGIN := 20
const ENEMIES_Y := ENEMIES_HAND_TOP_MARGIN + CARD_HEIGHT / 2.0
const MAX_NORMAL_ENEMIES := 3

const BATTLE_SCENE_PATH := "res://scenes/battle/Battle.tscn"
const BATTLE_VICTORY_SCENE_PATH := "res://scenes/battle_victory/BattleVictory.tscn"
const CARD_SCENE_PATH := "res://components/card/Card.tscn"
const CHARACTER_SELECTION_SCENE_PATH := "res://scenes/character_selection/CharacterSelection.tscn"
const ENEMY_CARD_SCENE_PATH := "res://components/enemy_card/EnemyCard.tscn"
const HOME_SCENE_PATH:= "res://scenes/home/Home.tscn"
const MAP_SCENE_PATH := "res://scenes/map/Map.tscn"
const PLAYER_IS_DEAD_SCENE_PATH := "res://scenes/player_is_dead/PlayerIsDead.tscn"
const SHOP_SCENE_PATH := "res://scenes/shop/Shop.tscn"

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

enum CardRarity {EMERALD, RUBY, DIAMOND}

const CARD_FRAMES: Dictionary[CardRarity, Texture2D] = {
	CardRarity.EMERALD: preload("res://assets/cards/card_emerald.jpg"),
	CardRarity.RUBY: preload("res://assets/cards/card_ruby.jpg"),
	CardRarity.DIAMOND: preload("res://assets/cards/card_diamond.jpg"),
}

const CARD_GEMS: Dictionary[CardRarity, Texture2D] = {
	CardRarity.EMERALD: preload("res://assets/cards/emerald.png"),
	CardRarity.RUBY: preload("res://assets/cards/ruby.png"),
	CardRarity.DIAMOND: preload("res://assets/cards/diamond.png"),
}

const PLAYER_CARD_PORTRAIT_DIR: String = "res://assets/player_cards/"
const ENEMY_CARD_PORTRAIT_DIR: String = "res://assets/enemy_cards/"
const MISSING_PORTRAIT: String = "res://assets/cards/missing_portrait.png"

const CARD_RARITY_WEIGHTS: Dictionary[LevelType, Dictionary] = {
	LevelType.NORMAL_BATTLE: {
		CardRarity.EMERALD: 65, CardRarity.RUBY: 25, CardRarity.DIAMOND: 10,
	},
	LevelType.ELITE_BATTLE: {
		CardRarity.EMERALD: 25, CardRarity.RUBY: 45, CardRarity.DIAMOND: 30,
	},
	LevelType.WORLD_BOSS_BATTLE: {
		CardRarity.DIAMOND: 100,
	},
	LevelType.SHOP: {
		CardRarity.EMERALD: 65, CardRarity.RUBY: 25, CardRarity.DIAMOND: 10,
	},
}

const CARD_UNLIMITED_COPIES := -1
