class_name ModuleBody extends Node2D

@onready var radius_viewer : RadiusViewer = $RadiusViewer
@export var shape : ParasolShape
var polygon : Array[Vector2] = []
var body_scale := 1.0

signal size_changed(new_size:float)

func activate() -> void:
	var rand_bs := Global.config.tourist_body_scale_bounds.rand_float()
	set_body_scale(rand_bs)

func set_body_scale(bs:float) -> void:
	body_scale = bs
	
	var points = shape.get_points()
	polygon = []
	for point in points:
		polygon.append(point * body_scale * 0.5 * Global.config.sprite_size)
	
	radius_viewer.set_radius(get_forbid_range())
	
	size_changed.emit(get_size())
	queue_redraw()

func get_polygon_global() -> Array[Vector2]:
	var arr : Array[Vector2] = []
	for point in polygon:
		arr.append(to_global(point))
	return arr

func get_size() -> float:
	return body_scale * Global.config.sprite_size

func get_forbid_range() -> float:
	return 0.5 * Global.config.tourist_parasol_forbid_range * get_size()

func is_in_range(pos:Vector2) -> bool:
	var dist := pos.distance_to(global_position)
	return dist <= get_forbid_range()

func _draw() -> void:
	if not (OS.is_debug_build() and Global.config.debug_bodies): return
	draw_polygon(polygon, [Color(1,1,1)])

func flash_radius() -> void:
	radius_viewer.animate_flash()
