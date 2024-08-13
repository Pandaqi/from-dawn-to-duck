extends Resource
class_name Config

@export_group("Debug")
@export var skip_pregame := true

@export_group("Map")
@export var sprite_size := 128.0
@export var map_size := Vector2(10, 8)

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2(32.0, 32.0)

@export_group("Light & Shadows")
var shadow_length_bounds := Bounds.new(0.5, 1.5) # ~sprite_size
@export var burn_base_health := 100.0
@export var burn_speed := 10.0 # per second
@export var cooldown_speed := 5.0
var burn_factor_bounds := Bounds.new(0.1, 1.0) # how the sun's intensity changes during the day

@export_group("Movement")
@export var lure_dist := 4.0 # ~sprite_size
@export var grab_dist := 1.0 # ~sprite_size
@export var move_speed_player := 6.0 # ~sprite_size
@export var move_speed_tourist := 2.5 # ~sprite_size

@export_group("Tourists")
@export_subgroup("Spawning")
var stay_duration_bounds := Bounds.new(0.25, 0.66)

@export_group("Progression")
@export var day_duration := 60.0
@export var day_duration_quick_end_factor := 0.25 # to make the day end much faster if all tourists are gone
@export var spawner_must_have_event_before := 0.1
@export var spawner_num_events_before := 2

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(val:Vector2) -> Vector2:
	return val * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
