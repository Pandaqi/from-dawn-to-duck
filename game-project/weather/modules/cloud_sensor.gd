class_name ModuleCloudSensor extends Node2D

@export var sun_rotator : ModuleSunRotator

var blocked := false

signal blocked_changed(is_blocked:bool)

func _process(_dt) -> void:
	scan_for_clouds()

func scan_for_clouds() -> void:
	var clouds := get_tree().get_nodes_in_group("Clouds")
	var our_line := sun_rotator.get_sight_line()
	var old_blocked := blocked
	
	# @TODO: this would fall apart if we ever have multiple suns, but that's fine
	# (because we'd be resetting the is_blocking_light on other stuff all the time)

	blocked = false
	for cloud in clouds:
		var cloud_line : Line = cloud.get_collider_line()
		var hit := Geometry2D.segment_intersects_segment(our_line.start, our_line.end, cloud_line.start, cloud_line.end) != null
		cloud.is_blocking_light = hit
		if not hit: continue
		blocked = true
	
	if blocked == old_blocked: return
	blocked_changed.emit(blocked)
		
