class_name ModuleMover extends Node2D

@export var input : ModuleInput
@export var map_data : MapData
@onready var entity = get_parent()

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal moved(vec:Vector2, speed:float)
signal stopped()

func activate() -> void:
	input.movement_vector_update.connect(on_move)

func on_move(dt: float, vec:Vector2) -> void:
	var base_speed := Global.config.scale(Global.config.move_speed_player)
	var move_vec := vec * base_speed * dt
	var new_pos : Vector2 = entity.get_position() + move_vec
	new_pos = map_data.wrap_position(new_pos)
	
	var is_moving := vec.length() > 0.003
	if not is_moving: 
		stopped.emit()
		audio_player.stop()
	else:
		moved.emit(move_vec, base_speed)
	
	if is_moving and not audio_player.playing:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()

	entity.set_position(new_pos)
