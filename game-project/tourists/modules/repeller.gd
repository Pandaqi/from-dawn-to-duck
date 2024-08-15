class_name ModuleRepeller extends Node2D

@export var map_data : MapData
@export var powerups_data : PowerupsData
@export var type_repel : PowerupType

# @NOTE: this just does a circle around the location and picks the first angle that would be fine
func get_repel_pos_within_bounds(pos:Vector2) -> Vector2:
	var vec := (global_position - pos).normalized()
	
	var repel_dist := get_repel_dist()
	var num_steps := 20
	var angle_diff := 2 * PI / num_steps
	var initial_pos := pos + vec * repel_dist
	for i in range(num_steps):
		var end_pos := pos + vec.rotated(i * angle_diff) * repel_dist
		if map_data.is_out_of_bounds(end_pos): continue
		return end_pos
	return initial_pos

func get_repel_dist() -> float:
	return Global.config.scale(Global.config.lure_repel_dist)

func get_repel_center(pos:Vector2) -> Vector2:
	var repel_powerups := powerups_data.get_of_type(type_repel)
	for powerup in repel_powerups:
		var dist := pos.distance_to(powerup.global_position)
		if dist > get_repel_dist(): continue
		return powerup.global_position
	return Vector2.ZERO
