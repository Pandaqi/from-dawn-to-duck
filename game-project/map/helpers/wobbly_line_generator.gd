class_name WobblyLineGenerator

var points : Array[Vector2]
var noise : Noise

func _init() -> void:
	points = []
	noise = FastNoiseLite.new()

func generate(start_pos:Vector2, end_pos:Vector2) -> void:
	var cur_pos := start_pos
	var dir := 1 if end_pos.x > start_pos.x else -1
	var increment := dir * Global.config.scale(Global.config.shore_line_increments)
	var displacement_scale := Global.config.scale(Global.config.shore_line_displacement)
	var noise_scale := Global.config.shore_line_noise_scale
	
	points = [cur_pos]
	while cur_pos.x*dir < end_pos.x*dir:
		var displacement := noise.get_noise_1d(cur_pos.x * noise_scale)
		cur_pos = Vector2(cur_pos.x + increment, start_pos.y + displacement * displacement_scale)
		points.append(cur_pos)
