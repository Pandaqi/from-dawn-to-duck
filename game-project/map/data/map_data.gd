extends Resource
class_name MapData

var bounds : Rect2

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
	
	var num_tries := 0
	var max_tries := 100
	
	while bad_pos and num_tries < max_tries:
		bad_pos = false
		rand_pos = get_random_position()
		num_tries += 1
		
		for node in avoid:
			var dist = node.global_position.distance_to(rand_pos)
			if dist < min_dist:
				bad_pos = true
				break
	
	return rand_pos
