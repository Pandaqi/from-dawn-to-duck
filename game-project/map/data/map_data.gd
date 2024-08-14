extends Resource
class_name MapData

var bounds : Rect2
var shore_line : WobblyLineGenerator
var tree_line : WobblyLineGenerator
var areas : Dictionary = {
	"trees": null,
	"beach": null,
	"water": null
}

const EXT := Vector2(600, 600)

func set_bounds(b:Rect2) -> void:
	bounds = b

func get_bounds() -> Rect2:
	return bounds

func get_random_position() -> Vector2:
	return bounds.position + Vector2(randf(), randf()) * bounds.size

func get_random_position_off_screen() -> Vector2:
	if randf() <= 0.5: return Vector2(0, randf() * bounds.size.y)
	return Vector2(bounds.size.x, randf() * bounds.size.y)

func query_position(params: Dictionary = {}) -> Vector2:
	var bad_pos := true
	var rand_pos : Vector2
	
	var avoid = params.avoid if ("avoid" in params) else []
	var min_dist = params.dist if ("dist" in params) else 0.0
	var fixed_points = params.points if ("points" in params) else []
	var area_margin = params.area_margin if ("area_margin" in params) else 0.0
	
	var area : MapArea = null
	if "area" in params:
		area = areas[params.area]
	
	var num_tries := 0
	var max_tries := 100
	
	while bad_pos and num_tries < max_tries:
		bad_pos = false
		rand_pos = get_random_position()
		
		if area:
			rand_pos = area.get_random_position(area_margin)
		
		if fixed_points.size() > 0:
			rand_pos = fixed_points.pick_random()
		
		num_tries += 1
		
		for node in avoid:
			var dist = node.global_position.distance_to(rand_pos)
			if dist < min_dist:
				bad_pos = true
				break
	
	return rand_pos

func generate() -> void:
	generate_lines()
	generate_areas()

func get_beach_y() -> float:
	return bounds.position.y + Global.config.map_y_beach_line * bounds.size.y

func get_water_y() -> float:
	return bounds.position.y + Global.config.map_y_water_line * bounds.size.y

func generate_lines() -> void:
	var bds := get_bounds()
	
	# the tree line (at the top)
	# (this one goes right to left, to keep counter-clockwise order for all)
	var screen_height := Global.config.map_y_beach_line
	var start_pos := Vector2(bds.position.x - EXT.x, bds.position.y + screen_height * bds.size.y)
	var end_pos := Vector2(bds.position.x + bds.size.x + EXT.x, start_pos.y)
	
	tree_line = WobblyLineGenerator.new()
	tree_line.generate(end_pos, start_pos)

	# the shore line (at the bottom, separating with water)
	screen_height = Global.config.map_y_water_line
	start_pos = Vector2(bds.position.x - EXT.x, bds.position.y + screen_height * bds.size.y)
	end_pos = Vector2(bds.position.x + bds.size.x + EXT.x, start_pos.y)
	
	shore_line = WobblyLineGenerator.new()
	shore_line.generate(start_pos, end_pos)

func generate_areas() -> void:
	
	# the trees area
	var a1 := MapArea.new()
	var tree_points := tree_line.points.duplicate()
	var top_left : Vector2 = tree_points.back()
	top_left.y = -EXT.y
	var top_right : Vector2 = tree_points.front()
	top_right.y = -EXT.y
	tree_points.append(top_left)
	tree_points.append(top_right)
	a1.points = tree_points
	a1.finalize(bounds)
	areas.trees = a1
	
	# the major beach area
	var a2 := MapArea.new()
	a2.points = shore_line.points.duplicate() + tree_line.points.duplicate()
	a2.finalize(bounds)
	areas.beach = a2
	
	# the water area
	var a3 = MapArea.new()
	var shore_points := shore_line.points.duplicate()
	var water_points : Array[Vector2] = []
	var bottom_right : Vector2 = shore_points.back()
	bottom_right.y = bounds.position.y + bounds.size.y + EXT.y
	var bottom_left : Vector2 = shore_points.front()
	bottom_left.y = bounds.position.y + bounds.size.y + EXT.y
	
	water_points.append(bottom_right)
	water_points.append(bottom_left)
	water_points += shore_points
	a3.points = water_points
	a3.finalize(bounds)
	areas.water = a3

func is_out_of_bounds(pos:Vector2) -> bool:
	return not (areas.beach.contains(pos) or areas.water.contains(pos))

func wrap_position(pos:Vector2) -> Vector2:
	if not is_out_of_bounds(pos): return pos
	
	if pos.x < bounds.position.x: pos.x += bounds.size.x
	if pos.x >= (bounds.position.x + bounds.size.x): pos.x -= bounds.size.x
	if pos.y < bounds.position.y: pos.y += bounds.size.y
	if pos.y >= (bounds.position.y + bounds.size.y): pos.y -= bounds.size.y
	return pos
