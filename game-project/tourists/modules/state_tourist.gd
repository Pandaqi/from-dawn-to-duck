class_name ModuleStateTourist extends Node2D

enum TouristState
{
	WALKING,
	SUNBATHING,
	LEAVING
}

var state := TouristState.WALKING
var spawn_event : SpawnEvent

@onready var label_debug := $LabelDebug

@export var state_module : ModuleState
@export var sun_burner : ModuleSunBurner
@export var target_follower : ModuleTargetFollower
@export var prog_data : ProgressionData

func activate() -> void:
	sun_burner.burned.connect(on_burned)
	target_follower.target_reached.connect(on_target_reached)
	target_follower.generate_changes(prog_data.time, spawn_event.time_leave)

	label_debug.set_text(str(spawn_event.time_leave))

func on_burned() -> void:
	state_module.kill(true)

func _process(_dt:float) -> void:
	check_if_should_change()

func check_if_should_change() -> void:
	if state != TouristState.SUNBATHING: return
	if target_follower.get_next_change_time() > prog_data.time: return
	
	if target_follower.is_done():
		leave()
		return
	
	reposition()

func on_target_reached() -> void:
	if state == TouristState.LEAVING:
		state_module.kill()
		return
	state = TouristState.SUNBATHING

func reposition() -> void:
	state = TouristState.WALKING
	target_follower.reposition()

func leave() -> void:
	target_follower.reset_to_starting_target()
	state = TouristState.LEAVING
	
	var reward_bounds := Global.config.tourist_coin_reward
	var reward := 0.0
	if Global.config.tourist_reward_scales_with_burn_factor:
		var ratio_inv := 1.0 - sun_burner.get_burn_ratio()
		reward = reward_bounds.interpolate(ratio_inv)
	else:
		reward = Global.config.tourist_coin_reward.rand_float()
	
	reward = int( round(reward * Global.config.base_price) )
	reward = max(reward, 1)
	prog_data.change_coins(reward)
	GSignal.feedback.emit(global_position, "+" + str(reward) + " coins!")

func is_burnable() -> bool:
	return state == TouristState.SUNBATHING or state == TouristState.WALKING
