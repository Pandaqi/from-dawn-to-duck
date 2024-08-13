class_name ModuleInput extends Node

@export var player_num : int = -1
var prev_move_vec := Vector2.ZERO
var epsilon := 0.03

signal movement_vector_update(vec, dt)
signal button_pressed()

func activate(num:int) -> void:
	player_num = num

func is_connected_to_player() -> bool:
	return player_num >= 0 and player_num < GInput.get_player_count()

func _physics_process(dt:float) -> void:
	if not is_connected_to_player(): return
	update_movement_vector(dt)

func update_movement_vector(dt:float) -> void:
	var move_vec := GInput.get_move_vec(player_num, false)
	prev_move_vec = move_vec
	movement_vector_update.emit(dt, move_vec)

func get_vector() -> Vector2:
	return prev_move_vec

func _input(ev:InputEvent) -> void:
	if GInput.is_action_released(ev, "interact", player_num):
		button_pressed.emit()
