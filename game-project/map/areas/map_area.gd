class_name MapArea

var points : Array[Vector2]
var points_simple : Array[Vector2]
var uvs : Array[Vector2]

func finalize(map_bounds:Rect2) -> void:
	
	# determine bounding box
	var bb_min := Vector2(INF, INF)
	var bb_max := Vector2(-INF, -INF)
	
	for point in points:
		bb_min.x = min(bb_min.x, point.x)
		bb_min.y = min(bb_min.y, point.y)
		bb_max.x = max(bb_max.x, point.x)
		bb_max.y = max(bb_max.y, point.y)
	
	# use it to assign uvs
	for point in points:
		var uv := (point - bb_min) / (bb_max - bb_min)
		uv.y = round(uv.y) # clamp to edges top or bottom
		uvs.append(uv)
	
	# then convert it to the simple area
	bb_min.x = max(bb_min.x, map_bounds.position.x)
	bb_min.y = max(bb_min.y, map_bounds.position.y)
	bb_max.x = min(bb_max.x, map_bounds.position.x + map_bounds.size.x)
	bb_max.y = min(bb_max.y, map_bounds.position.y + map_bounds.size.y)
	
	# limit bounding box to map_bounds for the simple area
	# (from top-left, counter clockwise again)
	points_simple = [
		bb_min,
		Vector2(bb_min.x, bb_max.y),
		bb_max,
		Vector2(bb_max.x, bb_min.y)
	]

func get_bounds() -> Rect2:
	return Rect2(points_simple[0], points_simple[2] - points_simple[0])

func get_random_position(edge_margin := 0.0) -> Vector2:
	var m := Vector2(edge_margin, edge_margin)
	var b := get_bounds()
	return b.position + m + (b.size - 2*m) * Vector2(randf(), randf())

func contains(pos:Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(pos, points_simple)
