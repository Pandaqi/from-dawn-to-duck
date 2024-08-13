class_name Camera extends Camera2D

@export var map : Map

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

func _process(dt:float) -> void:
	var bounds : Rect2 = map.map_data.get_bounds()
	if not bounds: return
	
	var target_position := bounds.get_center()
	
	var vp_size := get_viewport_rect().size - 2*Global.config.camera_edge_margin
	var desired_size := bounds.size
	var ratios := vp_size / desired_size
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))
