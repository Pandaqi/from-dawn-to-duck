class_name ModulePowerupSensor extends Node2D

@onready var entity = get_parent()

var powerups : Array[Powerup]

signal entered(p:Powerup)
signal exited(p:Powerup)

func _process(_dt:float) -> void:
	check_overlapping_powerups()

func check_overlapping_powerups() -> void:
	var powerup_nodes := get_tree().get_nodes_in_group("Powerups")
	var my_pos := global_position
	var old_powerups = powerups.duplicate()
	
	# first check the new state
	powerups = []
	for node in powerup_nodes:
		if not node.overlaps(my_pos): continue
		powerups.append(node)
	
	# then compare to old to see if something CHANGED for a specific powerup
	for p in powerups:
		if not old_powerups.has(p):
			p.powerup_executer.on_player_entered(entity)
			entered.emit(p)
	
	for p in old_powerups:
		if not powerups.has(p):
			p.powerup_executer.on_player_exited(entity)
			exited.emit(p)
