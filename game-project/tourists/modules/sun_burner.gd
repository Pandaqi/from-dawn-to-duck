class_name ModuleSunBurner extends Node2D

@export var shadow_tracker : ModuleShadowTracker
@export var state_tourist : ModuleStateTourist
@onready var prog_bar_cont := $ProgBar
@onready var prog_bar := $ProgBar/TextureProgressBar
@export var prog_data : ProgressionData
@export var state : ModuleState

var burn := 0.0
var base_burn := 100.0

signal protected()
signal burned()

func activate() -> void:
	GSignal.hand_to_ui.emit(prog_bar_cont)
	keep_prog_bar_with_us()
	
	set_base_burn(Global.config.burn_base_health)
	state.died.connect(on_died)

func set_base_burn(bb:float, refresh := true) -> void:
	base_burn = bb
	if refresh: reset()

func reset() -> void:
	change(-burn)

func _process(dt:float) -> void:
	keep_prog_bar_with_us()
	update_burn_status(dt)

func keep_prog_bar_with_us() -> void:
	var screen_pos := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()) * global_position
	prog_bar_cont.set_position(screen_pos)
	prog_bar_cont.set_scale(Global.config.progress_bars_scale*Vector2.ONE)

func update_burn_status(dt:float) -> void:
	if not state_tourist.is_burnable(): return
	
	var burn_change = Global.config.burn_speed * dt
	if shadow_tracker.is_in_shadow(): 
		burn_change = -Global.config.cooldown_speed * dt
	burn_change *= get_burn_factor()
	change(burn_change)

# this factor is 1.0 at the peak of the day (midday; hottest), 0 at the edges
func get_burn_factor() -> float:
	var factor : float = 1.0 - abs(prog_data.time - 0.5) / 0.5
	return Global.config.burn_factor_bounds.interpolate(factor)

func get_burn_ratio() -> float:
	return burn / base_burn

func change(db:float) -> void:
	burn = clamp(burn + db, 0.0, base_burn)
	
	var ratio := get_burn_ratio()
	prog_bar.set_value(ratio * 100.0)
	prog_bar.tint_progress = Global.config.burn_color_start.lerp(Global.config.burn_color_end, ratio)
	
	if ratio <= 0.0:
		protected.emit()
	elif ratio >= 1.0:
		burned.emit()

func on_died(_n:Node2D) -> void:
	prog_bar_cont.queue_free()
