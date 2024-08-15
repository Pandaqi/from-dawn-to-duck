class_name Shadow extends Node2D

var points_raw : PackedVector2Array = []
var points : PackedVector2Array = []
var point_uvs : PackedVector2Array = []
var active := false

var material_res = preload("res://parasols/shadows/shadow_pretty_shader.tres")

# @TODO: probably need unique shader and more tweaks, but this is a start
func _ready() -> void:
	material = material_res.duplicate(false)
	material.set_shader_parameter("color", Global.config.shadow_color)

func reset() -> void:
	show_behind_parent = true
	points_raw = []
	points = []
	point_uvs = []
	active = false

func add_point_raw(p:Vector2) -> void:
	points_raw.append(p)

func finalize() -> void:
	points = Geometry2D.convex_hull(points_raw)
	
	# create UV coordinates as if the points are in a circle;
	# this will allow the shader to easily find the _edges_ of this shape later
	point_uvs = []
	var num_points := points.size()
	for i in range(num_points):
		var angle := -i / float(num_points) * 2 * PI
		var uv := Vector2(0.5, 0.5) + 0.5*Vector2.from_angle(angle)
		point_uvs.append(uv)

func contains(p:Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(p, points)

func update() -> void:
	queue_redraw()

func _draw() -> void:
	if not active: return
	var points_local : PackedVector2Array = [] 
	for p in points:
		points_local.append(to_local(p))
	
	draw_polygon(points_local, [Global.config.shadow_color], point_uvs)
