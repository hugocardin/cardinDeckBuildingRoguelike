class_name CardUpgradeRule
extends RefCounted

static func max_upgrades(card: CardInstance) -> int:
	var def: Dictionary = card.def()
	var rule: Dictionary = def.get("upgrade", {})
	var result: int
	match rule.get("type", ""):
		"steps":
			var size: int = rule.get("list", []).size()
			var m: int = def.get("max_upgrades", size)
			result = size if m == Constants.CARD_INFINITE_UPGRADES else mini(m, size)
		"escalating", "flat":
			result = def.get("max_upgrades", 1)
		_:
			return 0   # no upgrade defined

	assert(result >= 0 or result == Constants.CARD_INFINITE_UPGRADES,
		"Invalid max_upgrades %d on card '%s'" % [result, card.card_id])
	return result

static func bonus(card: CardInstance, stat: String) -> int:
	var rule: Dictionary = card.def().get("upgrade", {})
	var level := card.upgrade_level
	match rule.get("type", ""):
		"flat":
			return rule.get(stat, 0) * level
		"escalating":
			if rule.get("stat") != stat: return 0
			var a: int = rule.get("start", 1)
			var d: int = rule.get("step", 1)
			@warning_ignore("integer_division")
			return a * level + d * level * (level - 1) / 2
		"steps":
			var steps: Array = rule.get("list", [])
			var total := 0
			for i: int in mini(level, steps.size()):
				total += steps[i].get(stat, 0)
			return total
	return 0
