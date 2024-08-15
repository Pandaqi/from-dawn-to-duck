extends Resource
class_name Config

@export_group("Debug")
@export var skip_pregame := true
@export var skip_postgame := true
@export var debug_bodies := false
@export var debug_disable_sound := false
@export var debug_labels := false

@export_group("Map")
@export var sprite_size := 256.0
@export var entity_size := 0.5 # ~sprite_size; generally, players and tourists are just half as large as everything else
@export var map_size := Vector2(16, 9)
@export var map_y_beach_line := 0.1
@export var map_y_water_line := 0.8
@export var shore_line_displacement := 0.5 # ~sprite_size
@export var shore_line_increments := 0.1 # ~sprite_size
@export var shore_line_noise_scale := 0.25
@export var y_squash_factor := 0.925 ## some things are squashed in Y-scale by this amount to make it fit the perspective better

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2.ZERO

@export_group("Light & Shadows")
var shadow_length_bounds := Bounds.new(0.6, 1.66) # ~sprite_size
@export var shadow_color := Color(0,0,0,0.75)
@export var burn_base_health := 100.0
@export var burn_speed := 9.0 # per second
@export var cooldown_speed := 3.5
var burn_factor_bounds := Bounds.new(0.85, 1.0) ## how the sun's intensity changes during the day automatically (based on time)
@export var burn_color_start := Color(1,1,1)
@export var burn_color_end := Color(1,1,1)

@export var dawn_color := Color(1,1,1)
@export var midday_color := Color(1,1,1)
@export var dusk_color := Color(1,1,1)
@export var night_color := Color(1,1,1)

@export var shadow_overlap_ratio_needed := 0.2 ## at least this % of a tourist's polygon points must be in shade before they are considered in shade

@export_group("Movement")
@export var lure_dist := 2.0 # ~sprite_size
@export var lure_on_button_press := true
@export var grab_dist := 1.0 # ~sprite_size
@export var move_speed_player := 6.0 # ~sprite_size
@export var move_speed_tourist := 2.5 # ~sprite_size

@export_group("Input & Actions")
@export var input_hold_enabled := true
@export var input_hold_threshold := 0.215 # seconds

@export_group("Tourists")
@export_subgroup("Spawning")
var stay_duration_bounds := Bounds.new(0.25, 0.66)
@export var stay_duration_increase_per_day := 0.05
@export var stay_duration_max := 0.8
@export var tourists_min_spawn_dist := 80.0
var tourist_body_scale_bounds := Bounds.new(0.5, 2.0) # ~sprite_size
@export var tourist_parasol_forbid_range := 1.5 # ~ sprite_size * personal scale

@export_group("Weather")
@export_subgroup("Heat")
var heat_bounds_min := Bounds.new(10, 22)
var heat_bounds_max := Bounds.new(25, 37)
var heat_extreme := 30 # above this number, the heat is considered extreme and dangerous
@export var heat_color_low := Color(1,1,1)
@export var heat_color_high := Color(1,1,1)
var heat_burn_factor_bounds := Bounds.new(0.65, 1.0) ## how the burn factor changes over time based on raw HEAT

@export_subgroup("Clouds")
var cloud_y := Bounds.new(0.005, 0.25) ## the y-pos at which clouds spawn; starts from beach line, not top of screen
@export var cloud_alpha := 0.66
var cloud_size_bounds := Bounds.new(1.5, 3.5) # ~sprite_size
var cloud_num_bounds := Bounds.new(0,2)
var cloud_stay_duration_bounds := Bounds.new(0.33, 0.75)
@export var weather_cloudy_darken_factor := 0.285

@export_group("Progression")
@export_subgroup("Day & Night")
@export var day_duration := 47.5
@export var day_duration_quick_end_factor := 0.275 ## to make the day end much faster if all tourists are gone
var day_time_bounds_hours := Bounds.new(6, 18) ## from 6 AM to 18 PM; must be symmetrical around midday
@export var sun_always_off_screen := true

@export_subgroup("Spawning")
@export var spawner_must_have_event_before := 0.1
@export var spawner_num_events_before := 2
@export var spawner_random_steps_factor := 1.75
var spawner_random_offset_bounds := Bounds.new(0.05, 0.095)
@export var spawner_random_increase_per_day := 0.15
@export var spawner_random_offset_increase_per_day := 0.025
@export var spawner_starting_tourists := 4
@export var spawner_extra_tourists_per_day := 1

@export_subgroup("Coins")
@export var coins_starting_num := 0
@export var base_price := 10
var tourist_coin_reward := Bounds.new(0.05, 0.33) ## ~base_price; this is related to the shop which always asks 1.0 for a new umbrella
var tourist_reward_scales_with_burn_factor := true
@export var lure_action_cost := 1

@export_subgroup("Lives")
@export var lives_starting_num := 1
@export var life_lost_means_parasol_lost := true

@export_group("Parasols")
@export var parasols_min_spawn_dist := 150.0
var shape_scale_bounds := Bounds.new(0.9, 1.35)
@export var parasol_rotate_speed := 2 * PI
@export var parasol_rotate_button_hold := true 
@export var parasols_can_be_inside_tourists := false
@export var parasols_starting_num := 2
@export var parasols_auto_spawn_per_day := 1 ## only activates if there are no shops on the map (i.e. that "system" is disabled)
@export var parasols_auto_spawn_interval := 2 ## "every X days, spawn the number above"
@export var parasol_colors : Array[Color] = []
@export var parasol_handle_size := 1.875 # ~sprite_size
@export var parasol_alpha_reveal_behind := 0.45 ## the alpha value when the parasol should reveal what is behind it
@export var parasol_outline_color_darken := 0.66
@export var parasol_outline_width := 0.1 # ~sprite_size

@export_group("Powerups")
@export var powerup_spawn_tick := 0.225 # ~day_duration
var powerup_spawn_bounds := Bounds.new(1,3)
var powerups_radius_bounds := Bounds.new(1.0, 1.55) # ~sprite_size
@export var powerup_spawn_prob := 0.66
@export var powerups_min_dist := 2.5 # ~sprite_size
@export var powerups_base_completion_value := 100.0
@export var powerups_completion_speed := 25.0 # per second
@export var powerups_day_stay_duration := 2 ## how many days a powerup stays before it removes itself (if not used before then)
@export var powerup_scalar_scale_factor := 1.25
@export var powerups_time_scale_factor := 1.2
@export var powerups_tutorials_min_dist := 3.0 # ~sprite_size
@export var powerups_progress_color_start := Color(1,1,1)
@export var powerups_progress_color_end := Color(1,1,1)
var powerup_coin_reward := Bounds.new(0.1, 0.3) # ~base_price
@export var powerup_heat_scale_factor := 0.725
@export var powerups_invert_if_lacking_money := true

@export_group("UI")
@export var progress_bars_scale := 0.15

@export_subgroup("Tutorial")
@export var tutorial_sprite_delay_time := 2.0
@export var tutorial_sprite_stay_time := 10.0

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(val:Vector2) -> Vector2:
	return val * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
