class_name ModuleState extends Node2D

@onready var entity = get_parent()

var dead := false

signal died(e:Node2D, is_bad:bool)

func kill(is_bad := false) -> void:
	if dead: return
	
	dead = true
	died.emit(entity, is_bad)
