class_name ModuleMover extends Node2D

@export var input : ModuleInput
@onready var entity = get_parent()

func activate() -> void:
	input.movement_vector_update.connect(on_move)

func on_move(dt: float, vec:Vector2) -> void:
	var base_speed := Global.config.scale(Global.config.move_speed_player)
	var new_pos = entity.get_position() + vec * base_speed * dt
	entity.set_position(new_pos)
