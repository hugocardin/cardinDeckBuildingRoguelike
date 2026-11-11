class_name CardUpgradeRule
extends RefCounted

static func max_upgrades(card: CardInstance) -> int:
	var def: Dictionary = card.definition()
	var rule: Dictionary = def.get("upgrade", {})
	match rule.get("type", ""):
		"steps":
			return rule["list"].size()
		"escalating", "flat":
			return def.get("max_upgrades", 1)
	return 0   # no upgrade defined

static func bonus(card: CardInstance, stat: String) -> int:
	var rule: Dictionary = card.definition().get("upgrade", {})
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
			var total := 0
			for i: int in mini(level, rule["list"].size()):
				total += rule["list"][i].get(stat, 0)
			return total
	return 0
