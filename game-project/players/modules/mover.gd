class_name ModuleMover extends Node2D

@export var input : ModuleInput
@export var map_data : MapData
@onready var entity = get_parent()

func activate() -> void:
	input.movement_vector_update.connect(on_move)

func on_move(dt: float, vec:Vector2) -> void:
	var base_speed := Global.config.scale(Global.config.move_speed_player)
	var move_vec := vec * base_speed * dt
	var new_pos : Vector2 = entity.get_position() + move_vec
	new_pos = map_data.wrap_position(new_pos)

	entity.set_position(new_pos)
