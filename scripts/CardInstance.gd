class_name CardInstance extends RefCounted
var card_id: String
var upgrade_level: int = 0

func _init(id: String, level: int = 0) -> void:
	card_id = id; upgrade_level = level

func max_upgrades() -> int:
	return CardDatabase.CARDS[card_id].get("upgrades", []).size()

func can_upgrade() -> bool:
	return upgrade_level < max_upgrades()

func upgrade() -> bool:
	if not can_upgrade(): return false
	upgrade_level += 1
	return true

func get_stat(stat: String) -> int:
	var def: Dictionary = CardDatabase.CARDS[card_id]
	var value: int = def.get(stat, 0)
	
	for i: int in upgrade_level:
		value += def["upgrades"][i].get(stat, 0)
		
	return value

func display_name() -> String:
	var base := card_id.capitalize()
	return base if upgrade_level == 0 else base + "+" + ("" if upgrade_level == 1 else str(upgrade_level))

func copy() -> CardInstance:
	return CardInstance.new(card_id, upgrade_level)
