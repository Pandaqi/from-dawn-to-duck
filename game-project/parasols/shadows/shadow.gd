class_name Shadow extends Node2D

var points_raw : PackedVector2Array = []
var points : PackedVector2Array = []
var active := false

func reset() -> void:
	show_behind_parent = true
	points_raw = []
	points = []
	active = false

func add_point_raw(p:Vector2) -> void:
	points_raw.append(p)

func finalize() -> void:
	points = Geometry2D.convex_hull(points_raw)

func contains(p:Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(p, points)

func update() -> void:
	queue_redraw()

func _draw() -> void:
	if not active: return
	var points_local : PackedVector2Array = [] 
	for p in points:
		points_local.append(to_local(p))
	
	draw_polygon(points_local, [Global.config.shadow_color])
