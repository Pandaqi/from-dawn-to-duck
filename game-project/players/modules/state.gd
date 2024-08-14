class_name ModuleState extends Node2D

@onready var entity = get_parent()

var dead := false

signal died(e:Node2D)

func kill(is_bad := false) -> void:
	if dead: return
	
	if is_bad:
		GSignal.life_lost.emit()
	
	dead = true
	died.emit(entity)
	entity.queue_free()
