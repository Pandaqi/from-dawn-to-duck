class_name Powerup extends Node2D

var type : PowerupType
var radius := 0.0
var dead := false

@onready var shadow_tracker : ModuleShadowTracker = $ShadowTracker
@onready var powerup_completer : ModulePowerupCompleter = $PowerupCompleter
@onready var powerup_executer : ModulePowerupExecuter = $PowerupExecuter
@onready var visuals : ModuleVisualsPowerup = $Visuals

signal died(p:Powerup)

func activate(tp:PowerupType) -> void:
	type = tp
	radius = Global.config.scale( Global.config.powerups_radius_bounds.rand_float() )
	
	
	powerup_completer.activate(tp)
	powerup_executer.activate()
	visuals.activate(tp, radius)
	
	powerup_completer.post_activate()

func overlaps(pos:Vector2) -> bool:
	return pos.distance_to(global_position) <= radius

func kill() -> void:
	if dead: return
	
	dead = true
	died.emit(self)
	self.queue_free()
