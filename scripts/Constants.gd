const CARD_DEFAULT_MOVE_DURATION := 0.1
const CARD_SCENE_PATH := "res://components/card/Card.tscn"
const CARD_SCALE_DEFAULT := Vector2(0.3, 0.3)
const CARD_SCALE_BIG := Vector2(0.33, 0.33)
const CARD_NATIVE_SIZE := Vector2(768, 1168)
const CARD_HEIGHT := CARD_NATIVE_SIZE[1] * CARD_SCALE_DEFAULT.y
const CARD_WIDTH := CARD_NATIVE_SIZE[0] * CARD_SCALE_DEFAULT.x

const DECK_DRAW_DURATION := 0.5
const DECK_POSITION := Vector2(150, 550)

const DISCARD_POSITION := Vector2(150, 550)

const ENEMIES_HAND_TOP_MARGIN := 20
const ENEMIES_Y := ENEMIES_HAND_TOP_MARGIN + CARD_HEIGHT / 2.0

const ENEMY_CARD_SCENE_PATH := "res://components/enemy_card/EnemyCard.tscn"

const PLAYER_CARD_COUNT := 4
const PLAYER_HAND_BOTTOM_MARGIN := 20

const MAP_ROWS := 8
const MAP_COLUMNS := 4
const MAP_NODE_SIZE := Vector2(128, 128)
const MAP_MIN_NODE_SPACING := 250
const MAP_NODE_CHANCE := 0.65

enum LevelType { NORMAL_BATTLE, ELITE_BATTLE, WORLD_BOSS_BATTLE, SHOP }

const LEVEL_ICONS := {
	Constants.LevelType.NORMAL_BATTLE: preload("res://assets/nodes/normal.png"),
	Constants.LevelType.ELITE_BATTLE: preload("res://assets/nodes/elite.png"),
	Constants.LevelType.WORLD_BOSS_BATTLE: preload("res://assets/nodes/boss.png"),
	Constants.LevelType.SHOP: preload("res://assets/nodes/shop.png")
}
