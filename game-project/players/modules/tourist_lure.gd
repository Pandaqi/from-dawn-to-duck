class_name TouristLure extends Node2D

var enabled := false
@export var input : ModuleInput

func activate() -> void:
	input.button_released.connect(on_button_pressed)

func on_button_pressed() -> void:
	if not enabled: return
	if not Global.config.lure_on_button_press: return
	lure()

func lure() -> void:
	var tourists := get_tree().get_nodes_in_group("Tourists")
	var lure_dist := Global.config.scale(Global.config.lure_dist)
	for tourist in tourists:
		var dist : float = tourist.global_position.distance_to(global_position)
		if dist > lure_dist: continue
		tourist.target_follower.lure(global_position)
