class_name NodeTypeRules
extends Resource

@export var type: Constants.LevelType
@export var weight: int
@export var max_consecutive: int = 1
@export var max_in_a_world: int = 99

static func make_rule(node_type: Constants.LevelType, weight_percent: int, 
					  max_consecutive_nodes: int, max_node_in_a_world: int) -> NodeTypeRules:
	var r := NodeTypeRules.new()
	r.type = node_type
	r.weight = weight_percent
	r.max_consecutive = max_consecutive_nodes
	r.max_in_a_world = max_node_in_a_world
	return r
	
static func get_rules() -> Array[NodeTypeRules]:
	return [
		NodeTypeRules.make_rule(Constants.LevelType.ELITE_BATTLE, 25, 2, 6),
		NodeTypeRules.make_rule(Constants.LevelType.SHOP, 15, 1, 3)
	]
