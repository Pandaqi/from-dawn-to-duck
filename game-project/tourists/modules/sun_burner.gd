class_name ModuleSunBurner extends Node2D

@export var shadow_tracker : ModuleShadowTracker
@export var state_tourist : ModuleStateTourist
@onready var prog_bar := $TextureProgressBar
@export var prog_data : ProgressionData

var burn := 0.0
var base_burn := 100.0

const BURN_SPEED := 10.0
const COOLDOWN_SPEED := 5.0
const BURN_FACTOR_MIN := 0.1
const BURN_FACTOR_MAX := 1.0

signal protected()
signal burned()

func activate() -> void:
	set_base_burn(Global.config.burn_base_health)

func set_base_burn(bb:float, refresh := true) -> void:
	base_burn = bb
	if refresh: reset()

func reset() -> void:
	change(-burn)

func _process(dt:float) -> void:
	update_burn_status(dt)

func update_burn_status(dt:float) -> void:
	if not state_tourist.is_burnable(): return
	
	var burn_change = Global.config.burn_speed * dt
	if shadow_tracker.is_in_shadow(): 
		burn_change = -Global.config.cooldown_speed * dt
	burn_change *= get_burn_factor()
	change(burn_change)

# this factor is 1.0 at the peak of the day (midday; hottest), 0 at the edges
func get_burn_factor() -> float:
	var factor : float = 1.0 - abs(prog_data.time - 0.5) / 0.5
	return Global.config.burn_factor_bounds.interpolate(factor)

func get_burn_ratio() -> float:
	return burn / base_burn

func change(db:float) -> void:
	burn = clamp(burn + db, 0.0, base_burn)
	
	var ratio := get_burn_ratio()
	prog_bar.set_value(ratio * 100.0)
	
	if ratio <= 0.0:
		protected.emit()
	elif ratio >= 1.0:
		burned.emit()
