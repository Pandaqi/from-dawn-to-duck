class_name ModuleShadowTracker extends Node2D

var shadows : Array[Shadow] = []

@onready var label_debug := $LabelDebug

signal shadow_changed(val:bool)

func _process(_dt:float) -> void:
	check_if_in_shadow()

func reset_shadows() -> void:
	shadows = []

func get_center() -> Vector2:
	return global_position

func is_in_shadow() -> bool:
	return shadows.size() > 0

func check_if_in_shadow() -> void:
	var was_in_shadow := is_in_shadow()
	
	reset_shadows()
	
	var shadow_casters := get_tree().get_nodes_in_group("ShadowCasters")
	for caster in shadow_casters:
		for shadow in caster.shadows:
			if not shadow.contains(get_center()): continue
			shadows.append(shadow)
	
	var is_shadowed := is_in_shadow()
	if was_in_shadow != is_shadowed:
		shadow_changed.emit(is_shadowed)
	
	label_debug.set_text("Burning")
	if is_shadowed:
		label_debug.set_text("SHADOW!")
