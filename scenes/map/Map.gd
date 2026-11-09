extends Node2D

func _ready() -> void:
	if GameState.current_map_nodes.is_empty():
		var nodes: Array[MapNode] = _generate_map()
		create_links(nodes)
		GameState.current_map_nodes = nodes
	_draw_map()

func _on_node_pressed(node: MapNode) -> void:
	EventBus.node_selected.emit(node)
	
static func _generate_map() -> Array[MapNode]:
	var nodes: Array = []
	var flat: Array[MapNode] = []
	var type_counts: Dictionary = {}
	var next_id := 0
	
	for r in range(Constants.MAP_ROWS):
		var row: Array = []
		row.resize(Constants.MAP_COLUMNS)
		var node_has_node := false
		for c in range(Constants.MAP_COLUMNS):
			if randf() > Constants.MAP_NODE_CHANCE:
				row[c] = null
				continue
			var parent_types: Array = []
			if r > 0:
				var prev_row: Array = nodes[r - 1]
				for prev in prev_row:
					if prev != null:
						parent_types.append(prev.type)
			var node_type := _pick_weighted_type(parent_types, type_counts)
			var node := MapNode.new()
			node.type = node_type
			node.id = next_id
			node.row = r
			node.col = c
			next_id += 1
			type_counts[node_type] = type_counts.get(node_type, 0) + 1
			row[c] = node
			flat.append(node)
			node_has_node = true
			
		# Guarantee at least one node per row
		if not node_has_node:
			var c := randi_range(0, Constants.MAP_COLUMNS - 1)
			var parent_types: Array = []
			if r > 0:
				var prev_row: Array = nodes[r - 1]
				for prev in prev_row:
					if prev != null:
						parent_types.append(prev.type)
			var node_type := _pick_weighted_type(parent_types, type_counts)
			var node := MapNode.new()
			node.type = node_type
			node.id = next_id
			node.row = r
			node.col = c
			next_id += 1
			type_counts[node_type] = type_counts.get(node_type, 0) + 1
			row[c] = node
			flat.append(node)
		nodes.append(row)
	
	# Boss at the top
	var boss := MapNode.new()
	boss.type = Constants.LevelType.WORLD_BOSS_BATTLE
	boss.id = next_id
	boss.row = Constants.MAP_ROWS
	boss.col = 0
	flat.append(boss)
	
	return flat

static func _pick_weighted_type(parent_types: Array, type_counts: Dictionary) -> Constants.LevelType:
	var valid_rules: Array[NodeTypeRules] = []
	var special_weight := 0
	for rule in NodeTypeRules.get_rules():
		if type_counts.get(rule.type, 0) >= rule.max_in_a_world:
			continue
		var consecutive := 0
		for pt in parent_types:
			if pt == rule.type:
				consecutive += 1
		if consecutive >= rule.max_consecutive:
			continue
		valid_rules.append(rule)
		special_weight += rule.weight
	var normal_weight := maxi(0, 100 - special_weight)
	var total := special_weight + normal_weight
	if total <= 0:
		return Constants.LevelType.NORMAL_BATTLE
	var roll := randi_range(1, total)
	var cumulative := 0
	for rule in valid_rules:
		cumulative += rule.weight
		if roll <= cumulative:
			return rule.type
	return Constants.LevelType.NORMAL_BATTLE

static func create_links(nodes: Array[MapNode]) -> void:
	for node in nodes:
		node.next = [] as Array[int]
	
	var rows: Array = []
	rows.resize(Constants.MAP_ROWS + 1)
	for i in range(rows.size()):
		rows[i] = []
	for node in nodes:
		rows[node.row].append(node)
	
	for r in range(Constants.MAP_ROWS):
		var current: Array = rows[r]
		var next_row: Array = rows[r + 1]
		if next_row.is_empty() or current.is_empty():
			continue
		
		current.sort_custom(func(a, b): return a.col < b.col)
		next_row.sort_custom(func(a, b): return a.col < b.col)
		
		var n_src := current.size()
		var n_tgt := next_row.size()
		
		for t in range(n_tgt):
			var s := int(float(t) / max(n_tgt, 1) * n_src)
			if s >= n_src:
				s = n_src - 1
			current[s].next.append(next_row[t].id)
		
		for s in range(n_src):
			if current[s].next.is_empty():
				var t := int(float(s) / max(n_src, 1) * n_tgt)
				if t >= n_tgt:
					t = n_tgt - 1
				current[s].next.append(next_row[t].id)

func _draw_map() -> void:
	var nodes := GameState.current_map_nodes
	
	# Clear previous icons and lines
	for child in $Nodes.get_children():
		child.queue_free()
	for child in get_children():
		if child is Sprite2D and child != $Nodes:
			child.queue_free()
	
	var buttons := {}
	var screen_size := get_viewport().get_visible_rect().size
	var screen_height := screen_size.y
	var screen_width := screen_size.x
	var top_margin := 80.0
	var bottom_margin := 80.0
	var side_margin := 60.0
	
	var total_rows := Constants.MAP_ROWS + 1  # 8 + boss
	var usable_height := screen_height - top_margin - bottom_margin - Constants.MAP_NODE_SIZE.y
	var row_spacing := usable_height / float(total_rows - 1) if total_rows > 1 else 0.0
	
	var rows: Array = []
	rows.resize(total_rows)
	for i in rows.size():
		rows[i] = []
	for node in nodes:
		rows[node.row].append(node)
	
	# Determine the row that should be enabled
	var current_row := -1
	if GameState.current_node != null:
		current_row = GameState.current_node.row

	var enabled_row := current_row + 1
	
	for row_nodes in rows:
		if row_nodes.is_empty():
			continue
		row_nodes.sort_custom(func(a, b): return a.col < b.col)
		var count = row_nodes.size()
		var spacing := float(Constants.MAP_MIN_NODE_SPACING)
		var max_width := screen_width - side_margin * 2.0
		if count > 1 and (count - 1) * spacing > max_width:
			spacing = max_width / float(count - 1)
		var total_width := float(count - 1) * spacing
		var first_center := (screen_width - total_width) / 2.0
		
		for i in count:
			var node = row_nodes[i]
			var btn := TextureButton.new()
			btn.texture_normal = Constants.LEVEL_ICONS[node.type]
			btn.ignore_texture_size = true
			btn.custom_minimum_size = Constants.MAP_NODE_SIZE
			btn.size = Constants.MAP_NODE_SIZE
			btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			btn.z_index = 1
			$Nodes.add_child(btn)
			btn.position = Vector2(
				first_center + i * spacing - Constants.MAP_NODE_SIZE.x / 2.0,
				screen_height - bottom_margin - Constants.MAP_NODE_SIZE.y - float(node.row) * row_spacing
			)
			
			# Only current row is enabled/clickable
			# Past rows (below) are greyed out + disabled
			# Future rows are disabled but keep normal color
			if node.row < enabled_row:
				# Past rows: greyed out + disabled
				btn.disabled = true
				btn.modulate = Color(0.4, 0.4, 0.4, 0.7)
			elif node.row > enabled_row:
				# Future rows: disabled, normal color
				btn.disabled = true
			else:
				# Enabled row: only reachable nodes are clickable
				var is_reachable := false
				if GameState.current_node == null:
					is_reachable = true  # start of map, all of first row available
				else:
					is_reachable = node.id in GameState.current_node.next

				if is_reachable:
					btn.disabled = false
					btn.pressed.connect(_on_node_pressed.bind(node))
				else:
					btn.disabled = true
					btn.modulate = Color(0.4, 0.4, 0.4, 0.7)
			
			buttons[int(node.id)] = btn
	
	# Draw paths (unchanged)
	for node in nodes:
		var from_btn := buttons.get(int(node.id)) as TextureButton
		if from_btn == null:
			continue
			
		for next_id in node.next:
			var to_btn := buttons.get(int(next_id)) as TextureButton
			if to_btn == null:
				continue
			var from_center := from_btn.position + Constants.MAP_NODE_SIZE / 2.0
			var to_center := to_btn.position + Constants.MAP_NODE_SIZE / 2.0
			var delta := to_center - from_center
			var sprite := Sprite2D.new()
			sprite.texture = Constants.PATH_PATH
			sprite.centered = true
			sprite.position = (from_center + to_center) * 0.5
			sprite.rotation = delta.angle()
			sprite.scale = Vector2(delta.length() / Constants.PATH_PATH.get_width(), 0.15)
			sprite.z_index = 0
			add_child(sprite)
