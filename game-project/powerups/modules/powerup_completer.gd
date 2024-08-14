class_name ModulePowerupCompleter extends Node2D

@export var shadow_tracker : ModuleShadowTracker
@onready var prog_bar_cont := $ProgBar
@onready var prog_bar := $ProgBar/TextureProgressBar
@onready var entity : Powerup = get_parent()

var value := 0.0
var base_value := 100.0
var type : PowerupType

signal completed(tp:PowerupType)

func activate(tp:PowerupType) -> void:
	type = tp
	
	GSignal.hand_to_ui.emit(prog_bar_cont)
	keep_prog_bar_with_us()
	
	entity.died.connect(on_died)
	
	var val := Global.config.powerups_base_completion_value * tp.completion_duration_factor
	set_base_value(val)
	
	if tp.instant_process:
		complete()

func set_base_value(val:float, refresh := true) -> void:
	base_value = val
	if refresh: reset()

func reset() -> void:
	change(-value)
	if type.instant_process: complete()

func complete() -> void:
	change(base_value)

func _process(dt:float) -> void:
	keep_prog_bar_with_us()
	update_status(dt)

func keep_prog_bar_with_us() -> void:
	var screen_pos := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()) * global_position
	prog_bar_cont.set_position(screen_pos)
	prog_bar_cont.set_scale(Global.config.progress_bars_scale*Vector2.ONE)

func update_status(dt:float) -> void:
	if not shadow_tracker.is_in_shadow(): return
	var value_change := Global.config.powerups_completion_speed * dt
	change(value_change)

func get_ratio() -> float:
	return value / base_value

func change(db:float) -> void:
	value = clamp(value + db, 0.0, base_value)
	
	var ratio := get_ratio()
	prog_bar.set_value(ratio * 100.0)
	prog_bar.tint_progress = Global.config.powerups_progress_color_start.lerp(Global.config.powerups_progress_color_end, ratio)
	
	if ratio >= 1.0:
		on_completion()

func on_completion() -> void:
	if type.needs_visit or type.continuous:
		GSignal.feedback.emit(global_position, "Powerup Ready!")
	completed.emit(type)

func on_died(_p:Powerup) -> void:
	prog_bar_cont.queue_free()
