class_name CardInstance extends RefCounted
var card_id: String
var upgrade_level: int = 0

func _init(id: String, level: int = 0) -> void:
	card_id = id; upgrade_level = level

func def() -> Dictionary:
	return CardDatabase.CARDS[card_id]

func max_upgrades() -> int:
	return CardUpgradeRule.max_upgrades(self)

func can_upgrade() -> bool:
	var m := max_upgrades()
	return m == Constants.CARD_INFINITE_UPGRADES or upgrade_level < m

func upgrade() -> void:
	if can_upgrade(): 
		upgrade_level += 1
	
func get_stat(stat: String) -> int:
	return def().get(stat, 0) + CardUpgradeRule.bonus(self, stat)

func get_attack() -> int:
	return get_stat("attack")
	
func get_shield() -> int:
	return get_stat("shield")
	
func display_name() -> String:
	var base := card_id.capitalize()
	return base if upgrade_level == 0 else base + "+" + ("" if upgrade_level == 1 else str(upgrade_level))

func display_rarity() -> String:
	var rarity: Constants.CardRarity = def().get("rarity", Constants.CardRarity.COMMON)
	return Constants.CardRarity.find_key(rarity)
	
func copy() -> CardInstance:
	return CardInstance.new(card_id, upgrade_level)
