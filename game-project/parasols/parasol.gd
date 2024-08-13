class_name Parasol extends Node2D

@onready var handle := $Handle

func get_handle_position() -> Vector2:
	return handle.global_position
