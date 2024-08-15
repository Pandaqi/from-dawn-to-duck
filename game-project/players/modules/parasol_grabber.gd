class_name ModuleParasolGrabber extends Node2D

var parasol : Parasol = null
var button_drops_parasol := true
var button_grabs_parasol := false
var enabled := true
var last_parasol_dropped : Parasol = null

var holding_button := false
var button_press_time := 0.0

@export var input : ModuleInput

@export var powerups_data : PowerupsData
@export var rotate_type : PowerupType
@export var drop_type : PowerupType

@onready var entity = get_parent()

signal changed(p:Parasol)
signal dropped()

func activate() -> void:
	input.button_pressed.connect(on_button_pressed)
	input.button_released.connect(on_button_released)

func _process(dt:float) -> void:
	keep_with_player()
	rotate_parasol_if_needed(dt)
	if not button_grabs_parasol:
		check_for_parasols_in_range()

func keep_with_player() -> void:
	if not has_parasol(): return
	parasol.set_position(global_position)

func rotate_parasol_if_needed(dt:float) -> void:
	if not has_parasol(): return
	if not holding_button: return
	if not Global.config.parasol_rotate_button_hold: return
	if not input_was_held(): return
	if not powerups_data.rotate_enabled: return
	rotate_parasol(dt)

func rotate_parasol(dt:float) -> void:
	var rotate_speed := Global.config.parasol_rotate_speed * dt
	parasol.shadow_caster.update_rotation(rotate_speed)

func check_for_parasols_in_range() -> void:
	if has_parasol(): return
	if not enabled: return
	
	var paras := get_tree().get_nodes_in_group("Parasols")
	var grab_dist := Global.config.scale(Global.config.grab_dist)
	
	var closest_para : Parasol = null
	var closest_dist := INF
	
	for para in paras:
		var dist : float = para.get_handle_position().distance_to(global_position)
		if dist > grab_dist: continue
		if dist > closest_dist: continue
		closest_dist = dist
		closest_para = para
	
	if not closest_para or closest_para != last_parasol_dropped:
		last_parasol_dropped = null 
	
	if not closest_para: return
	grab(closest_para)

func has_parasol() -> bool:
	return parasol != null

func can_grab(p:Parasol) -> bool:
	return p != last_parasol_dropped

func grab(p:Parasol) -> void:
	if has_parasol(): return
	if not can_grab(p): return
	parasol = p
	parasol.on_grabbed(entity)
	animate_pop_up(parasol)
	changed.emit(parasol)

func drop() -> void:
	if not has_parasol(): return
	if not can_drop(): return
	
	parasol.set_position(get_drop_position())
	last_parasol_dropped = parasol
	parasol.on_dropped()
	parasol = null
	animate_pop_up(last_parasol_dropped)
	dropped.emit()

func animate_pop_up(p:Parasol) -> void:
	var tw := get_tree().create_tween()
	var rand_dur := randf_range(0.04, 0.08)
	var rand_scale := randf_range(0.9, 1.1)
	
	tw.tween_property(p, "scale", Vector2(1.2, 0.8) * rand_scale, rand_dur)
	tw.tween_property(p, "scale", Vector2(0.8, 1.2) * rand_scale, rand_dur)
	tw.tween_property(p, "scale", Vector2.ONE, rand_dur)

func get_time_since_button_press() -> float:
	return (Time.get_ticks_msec() - button_press_time) / 1000.0

func get_drop_position() -> Vector2:
	return global_position

func on_button_pressed() -> void:
	holding_button = true
	button_press_time = Time.get_ticks_msec()

func input_was_held() -> bool:
	if not Global.config.input_hold_enabled: return false
	return get_time_since_button_press() > Global.config.input_hold_threshold

func on_button_released() -> void:
	holding_button = false
	
	if button_drops_parasol and not input_was_held(): 
		if powerups_data.drop_enabled:
			drop()
	
	if button_grabs_parasol and not input_was_held(): 
		check_for_parasols_in_range()

func can_drop() -> bool:
	if Global.config.parasols_can_be_inside_tourists: return true
	
	var bodies = get_tree().get_nodes_in_group("Bodies")
	var pos := get_drop_position()
	for body in bodies:
		if body.is_in_range(pos):
			GSignal.feedback.emit(global_position, "Too close!")
			body.flash_radius()
			return false
	return true
