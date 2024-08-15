class_name ModuleTouristLure extends Node2D

var enabled := false
@export var input : ModuleInput
@onready var radius_viewer : RadiusViewer = $RadiusViewer
@export var parasol_grabber : ModuleParasolGrabber
@export var powerups_data : PowerupsData
@export var prog_data : ProgressionData

func activate() -> void:
	input.button_released.connect(on_button_pressed)
	radius_viewer.set_radius(get_lure_range())

func on_button_pressed() -> void:
	if not enabled: return
	if not Global.config.lure_on_button_press: return
	if parasol_grabber.has_parasol(): return
	if not powerups_data.luring_enabled: return
	if not can_pay(): 
		GSignal.feedback.emit(global_position, "Need Money!")
		return
	lure()

func can_pay() -> bool:
	var action_cost := Global.config.lure_action_cost
	if action_cost <= 0: return true
	return prog_data.coins >= action_cost

func get_lure_range() -> float:
	return Global.config.scale(Global.config.lure_dist)

func get_tourists_in_range() -> Array[Tourist]:
	var tourists := get_tree().get_nodes_in_group("Tourists")
	var lure_range := get_lure_range()
	var arr : Array[Tourist] = []
	for tourist in tourists:
		var dist : float = tourist.global_position.distance_to(global_position)
		if dist > lure_range: continue
		arr.append(tourist as Tourist)
	return arr

func lure() -> void:
	GSignal.feedback.emit(global_position, "Hey, come closer!")
	
	var did_something := false
	for tourist in get_tourists_in_range():
		tourist.target_follower.lure(global_position)
		did_something = true
	
	if not did_something: return
	prog_data.change_coins(-Global.config.lure_action_cost)

func repel() -> void:
	GSignal.feedback.emit(global_position, "Shoo! Shoo!")
	
	for tourist in get_tourists_in_range():
		tourist.target_follower.repel(global_position)
