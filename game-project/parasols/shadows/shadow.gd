class_name Shadow extends Node2D

var points_raw : PackedVector2Array = []
var points : PackedVector2Array = []
var active := false

func reset() -> void:
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
	draw_polygon(points, [Color(1,1,1,0.5)])
