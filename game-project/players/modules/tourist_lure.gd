class_name TouristLure extends Node2D

var enabled := false
@export var input : ModuleInput
@onready var radius_viewer : RadiusViewer = $RadiusViewer
@export var parasol_grabber : ModuleParasolGrabber

func activate() -> void:
	input.button_released.connect(on_button_pressed)
	radius_viewer.set_radius(get_lure_range())

func on_button_pressed() -> void:
	if not enabled: return
	if not Global.config.lure_on_button_press: return
	if parasol_grabber.has_parasol(): return
	lure()

func get_lure_range() -> float:
	return Global.config.scale(Global.config.lure_dist)

func lure() -> void:
	var tourists := get_tree().get_nodes_in_group("Tourists")
	var lure_range := get_lure_range()
	for tourist in tourists:
		var dist : float = tourist.global_position.distance_to(global_position)
		if dist > lure_range: continue
		tourist.target_follower.lure(global_position)
