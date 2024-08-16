class_name ModuleShadowTracker extends Node2D

var shadows : Array[Shadow] = []
var in_shadow := false

@export var body : ModuleBody
@onready var label_debug := $LabelDebug
@onready var entity = get_parent()
@export var weather_data : WeatherData
@export var state_tourist : ModuleStateTourist

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal shadow_changed(is_shadowed:bool)

func activate() -> void:
	label_debug.set_visible(OS.is_debug_build() and Global.config.debug_labels)
	on_shadow_changed()

func _process(_dt:float) -> void:
	check_if_in_shadow()

func reset_shadows() -> void:
	shadows = []

func get_center() -> Vector2:
	return global_position

func is_in_shadow() -> bool:
	return in_shadow

func calculate_if_in_shadow() -> bool:
	if state_tourist and not state_tourist.is_burnable(): return true
	return shadows.size() > 0 or weather_data.cloudy

func check_if_in_shadow() -> void:
	if not entity.is_visible(): return
	
	var was_in_shadow := in_shadow
	
	reset_shadows()
	
	var shadow_casters := get_tree().get_nodes_in_group("ShadowCasters")
	# if we have no body, juts use our center for these checks
	var body_poly := [global_position]
	if body: body_poly = body.get_polygon_global()
	var num_body_points := body_poly.size()
	var target_ratio_overlap := Global.config.shadow_overlap_ratio_needed
	
	for caster in shadow_casters:
		for shadow in caster.shadows:
			var num_overlaps := 0
			for point in body_poly:
				if not shadow.contains(point): continue
				num_overlaps += 1
			
			var ratio_overlapped := num_overlaps / float(num_body_points)
			if ratio_overlapped < target_ratio_overlap: continue
			shadows.append(shadow)
	
	in_shadow = calculate_if_in_shadow()
	if was_in_shadow != in_shadow:
		on_shadow_changed()
	
	label_debug.set_text("Burning")
	if in_shadow:
		label_debug.set_text("SHADOW!")

func on_shadow_changed() -> void:
	shadow_changed.emit(in_shadow)
	if (not in_shadow) and audio_player:
		audio_player.pitch_scale = randf_range(0.93, 1.07)
		audio_player.play()
