class_name ModulePowerupCompleter extends Node2D

@export var shadow_tracker : ModuleShadowTracker
@onready var prog_bar_cont := $ProgBar
@onready var prog_bar := $ProgBar/TextureProgressBar
@onready var entity : Powerup = get_parent()
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

var value := 0.0
var base_value := 100.0
var type : PowerupType
var num_completes := 0
var is_already_completed := false

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
	if type.instant_process: return
	
	is_already_completed = false
	change(-value)

func complete() -> void:
	change(base_value)

func _process(dt:float) -> void:
	keep_prog_bar_with_us()
	update_status(dt)

func keep_prog_bar_with_us() -> void:
	var screen_pos := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()) * global_position
	prog_bar_cont.set_position(screen_pos)
	prog_bar_cont.set_scale(Global.config.progress_bars_scale*Vector2.ONE)
	prog_bar_cont.set_visible(entity.is_visible())

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
	if is_already_completed: return
	
	is_already_completed = true
	num_completes += 1
	
	if type.needs_visit:
		GSignal.feedback.emit(global_position, "Powerup Ready!")
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
	completed.emit(type)

func on_died(_p:Powerup) -> void:
	prog_bar_cont.queue_free()
