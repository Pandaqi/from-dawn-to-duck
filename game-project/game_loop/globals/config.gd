extends Resource
class_name Config

@export_group("Debug")
@export var skip_pregame := true

@export_group("Map")
@export var sprite_size := 128.0
@export var map_size := Vector2(16, 9)
@export var map_y_beach_line := 0.1
@export var map_y_water_line := 0.8
@export var shore_line_displacement := 0.5 # ~sprite_size
@export var shore_line_increments := 0.1 # ~sprite_size
@export var shore_line_noise_scale := 0.25

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2.ZERO

@export_group("Light & Shadows")
var shadow_length_bounds := Bounds.new(0.5, 1.5) # ~sprite_size
@export var shadow_color := Color(0,0,0,0.75)
@export var burn_base_health := 100.0
@export var burn_speed := 10.0 # per second
@export var cooldown_speed := 5.0
var burn_factor_bounds := Bounds.new(0.1, 1.0) # how the sun's intensity changes during the day

@export var dawn_color := Color(1,1,1)
@export var midday_color := Color(1,1,1)
@export var dusk_color := Color(1,1,1)
@export var night_color := Color(1,1,1)

@export_group("Movement")
@export var lure_dist := 4.0 # ~sprite_size
@export var grab_dist := 1.0 # ~sprite_size
@export var move_speed_player := 6.0 # ~sprite_size
@export var move_speed_tourist := 2.5 # ~sprite_size

@export_group("Input & Actions")
@export var input_hold_enabled := true
@export var input_hold_threshold := 0.3 # seconds

@export_group("Tourists")
@export_subgroup("Spawning")
var stay_duration_bounds := Bounds.new(0.25, 0.66)
@export var tourists_min_spawn_dist := 80.0

@export_group("Progression")
@export_subgroup("Day & Night")
@export var day_duration := 60.0
@export var day_duration_quick_end_factor := 0.25 # to make the day end much faster if all tourists are gone

@export_subgroup("Spawning")
@export var spawner_must_have_event_before := 0.1
@export var spawner_num_events_before := 2
@export var spawner_random_steps_factor := 2.5
@export var spawner_random_offset_max := 0.095

@export_subgroup("Coins")
@export var base_price := 5
@export var parasol_price := 1.0 # ~base_price
var tourist_coin_reward := Bounds.new(0.33, 0.66) # ~base_price

@export_group("Parasols")
@export var parasols_min_spawn_dist := 150.0
var shape_scale_bounds := Bounds.new(0.85, 1.15)
@export var parasol_rotate_speed := 2 * PI
@export var parasol_rotate_button_hold := true 
@export var parasols_starting_num := 2
@export var parasols_auto_spawn_per_day := 1
@export var parasols_auto_spawn_interval := 2 # "every X days, spawn the number above"

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(val:Vector2) -> Vector2:
	return val * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
