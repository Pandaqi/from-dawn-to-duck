extends Resource
class_name PowerupType

@export var frame : int = 0 ## frame in spritesheet
@export var desc := "" ## one-liner explanation of what it does
@export var color := Color(1,1,1) ## color of the area on the beach floor
@export var instant_process := false ## you can instantly use this, no completion process needed
@export var single_use := false ## after using it once, it goes away
@export var continuous := false ## while inside, its effects are continuously applied
@export var needs_visit = false ## after completing, they still need to be visited by a player (usually because its effect relates to a specific player/instant)
@export var completion_duration_factor := 1.0 ## scales how long it takes to complete/grab this powerup
@export var cost := 0.0 ## how many coins it takes to execute this, scaled by base price in Config
@export var reset_on_failure_only := false ## by default, it resets after every (discrete) usage; this, if true, only resets if something went wrong
@export var days_until_removal_factor := 1.0
@export var never_remove := false

@export var min_num := 0
@export var max_num := 5

## returns if it was a success (true) or if it failed (false)
func execute(_pe:ModulePowerupExecuter, _dt:float) -> bool:
	return true

func get_cost() -> int:
	return int(round(cost * Global.config.base_price))

func can_pay_with(coins:int) -> bool:
	return get_cost() <= coins
