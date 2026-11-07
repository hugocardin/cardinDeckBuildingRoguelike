extends Node2D

const ROWS := 8
const MIN_PER_ROW := 2
const MAX_PER_ROW := 4

func _ready() -> void:
	var nodes = _generate_map()
	GameState.current_map_nodes = nodes
	_draw_map(nodes)

func _on_node_pressed(node) -> void:
	print("Selected: ", node.type, " id:", node.id)

static func _generate_map() -> Array[MapNode]:
	var nodes: Array[MapNode] = []
	var id := 0
	
	for row in ROWS:
		var count = 1 if row == ROWS - 1 else MAX_PER_ROW
		for col in count:
			var node = MapNode.new()
			node.id = id
			node.row = row
			node.col = col
			node.type = Constants.LevelType.NORMAL_BATTLE
			if row == ROWS - 1:
				node.type = Constants.LevelType.WORLD_BOSS_BATTLE
			elif row > 0 and randf() < 0.15:
				node.type = Constants.LevelType.ELITE_BATTLE
			nodes.append(node)
			id += 1
	
	# Each node points to the one directly above (same col)
	for node in nodes:
		if node.row == ROWS - 1:
			continue
		for other in nodes:
			if other.row == node.row + 1 and other.col == node.col:
				node.next.append(other.id)
				break
		# Last row has only 1 boss; link all of the previous row to it
		if node.row == ROWS - 2:
			for other in nodes:
				if other.row == ROWS - 1:
					if other.id not in node.next:
						node.next.append(other.id)
	
	return nodes

func _draw_map(nodes: Array) -> void:
	var positions := {}
	var buttons := {}
	var screen_height = get_viewport().get_visible_rect().size.y
	var screen_width = get_viewport().get_visible_rect().size.x
	var top_margin := 80.0
	var bottom_margin := 80.0
	var usable = screen_height - top_margin - bottom_margin
	var row_height = usable / (ROWS - 1)
	var col_width = screen_width / MAX_PER_ROW
	
	for node in nodes:
		var btn = Button.new()
		btn.text = Constants.LevelType.keys()[node.type]
		add_child(btn)
		
		var x: float
		if node.type == Constants.LevelType.WORLD_BOSS_BATTLE:
			x = (screen_width - btn.size.x) / 2.0
		else:
			x = col_width * node.col + (col_width - btn.size.x) / 2.0
		
		var y = screen_height - bottom_margin - node.row * row_height
		btn.position = Vector2(x, y)
		btn.pressed.connect(_on_node_pressed.bind(node))
		
		positions[node.id] = btn.position
		buttons[node.id] = btn
	
	for node in nodes:
		for next_id in node.next:
			var from_btn = buttons[node.id]
			var to_btn = buttons[next_id]
			var from_edge = Vector2(from_btn.position.x + from_btn.size.x / 2, from_btn.position.y)
			var to_edge = Vector2(to_btn.position.x + to_btn.size.x / 2, to_btn.position.y + to_btn.size.y)
			
			var line = Line2D.new()
			line.width = 2
			line.default_color = Color.WHITE
			line.add_point(from_edge)
			line.add_point(to_edge)
			add_child(line)
