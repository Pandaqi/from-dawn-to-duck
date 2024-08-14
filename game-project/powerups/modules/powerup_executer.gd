class_name ModulePowerupExecuter extends Node2D

@export var powerup_completer : ModulePowerupCompleter
@export var prog_data : ProgressionData
@onready var entity : Powerup = get_parent()

var day_added := 0
var open_for_visit := false
var type : PowerupType = null
var players_here : Array[Player] = []

func activate() -> void:
	day_added = prog_data.day
	powerup_completer.completed.connect(on_completed)
	prog_data.day_started.connect(on_day_started)

func on_day_started() -> void:
	remove_if_too_old()

func remove_if_too_old() -> void:
	if not type: return
	if type.never_remove: return
	
	var days_passed := prog_data.day - day_added
	var max_stay : int = round(Global.config.powerups_day_stay_duration * type.days_until_removal_factor)
	if days_passed < max_stay: return
	entity.kill()

func is_valid() -> bool:
	return type != null and open_for_visit

func reset() -> void:
	open_for_visit = false
	powerup_completer.reset()

func on_completed(tp:PowerupType) -> void:
	type = tp
	open_for_visit = true
	
	if tp.needs_visit: return
	execute()

func on_player_entered(p:Player) -> void:
	players_here.append(p)
	if (not is_valid()) or type.continuous: return
	execute()

func on_player_exited(p:Player) -> void:
	players_here.erase(p)

func _process(dt:float) -> void:
	if not is_valid(): return
	execute_continuously_if_needed(dt)

func execute_continuously_if_needed(dt:float) -> void:
	if not type.continuous: return
	execute(dt)

func execute(dt := 0.0) -> void:
	var success := false
	if type.can_pay_with(prog_data.coins):
		success = type.execute(self, dt)
	else:
		GSignal.feedback.emit(global_position, "Need Money!")
	
	if success:
		prog_data.change_coins(-type.get_cost())
	
	if type.single_use:
		entity.kill()
		return
	
	# if it's not a continuous thing, it resets after every usage
	var discrete_trigger := is_zero_approx(dt)
	var should_reset := (not type.reset_on_failure_only) or (not success)
	if discrete_trigger and should_reset:
		reset()
