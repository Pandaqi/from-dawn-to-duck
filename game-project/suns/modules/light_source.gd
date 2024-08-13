class_name ModuleLightSource extends Node2D

enum LightSourceType
{
	DIRECTIONAL,
	POINT
}

# @onready var entity = get_parent()

@export var type := LightSourceType.DIRECTIONAL
@export var shadow_dist_min := 10.0
@export var shadow_dist_max := 50.0

var enabled := true

# @TODO: Here we'd probably have variables about distance of light, color, strength, any other special properties, etcetera

func set_enabled(val:bool) -> void:
	enabled = val

func get_origin() -> Vector2:
	return global_position

func get_shadow_dir(target_pos:Vector2) -> Vector2:
	if type == LightSourceType.POINT:
		return (target_pos - get_origin()).normalized()
	
	if type == LightSourceType.DIRECTIONAL:
		return Vector2.from_angle(global_rotation)
	
	return Vector2.ZERO

func get_shadow_distance(target_pos:Vector2) -> float:
	var dist_bounds := Global.config.scale_bounds(Global.config.shadow_length_bounds)
	
	if type == LightSourceType.POINT:
		return dist_bounds.end
	
	if type == LightSourceType.DIRECTIONAL:
		var angle := get_shadow_dir(target_pos).angle()
		if angle < 0: angle += 2*PI
		var dist : float = abs(angle - 0.5*PI)
		
		# 0.0 is pointed perfectly down (midday sun), 1.0 if pointed perfectly to left or right
		var ratio : float = clamp(dist / 0.5 * PI, 0.0, 1.0)
		return dist_bounds.interpolate(ratio)
	
	return 0.0
