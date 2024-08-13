class_name TouristLure extends Node2D

var enabled := false
@export var input : ModuleInput

func activate() -> void:
	input.button_released.connect(lure_nearby_tourists)

func lure_nearby_tourists() -> void:
	if not enabled: return
	
	var tourists := get_tree().get_nodes_in_group("Tourists")
	var lure_dist := Global.config.scale(Global.config.lure_dist)
	for tourist in tourists:
		var dist : float = tourist.global_position.distance_to(global_position)
		if dist > lure_dist: continue
		tourist.target_follower.lure(global_position)
