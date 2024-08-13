extends Resource
class_name ParasolShape

@export var points : Array[Vector2]
@export var circle_resolution := 0
@export var circle_angles := { "min": 0.0, "max": 2.0 * PI }

func get_points() -> Array[Vector2]:
	if circle_resolution > 0 and points.size() <= 0:
		create_circle_points()
	return points

func create_circle_points() -> void:
	points = []
	var full_circle := is_equal_approx( circle_angles.max - circle_angles.min, 2*PI)
	var divider := circle_resolution if full_circle else (circle_resolution - 1) 
	var step_size = (circle_angles.max - circle_angles.min) / divider
	for i in range(circle_resolution):
		var ang : float = circle_angles.min + i * step_size
		var point := Vector2.from_angle(ang) 
		points.append(point)
