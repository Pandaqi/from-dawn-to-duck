class_name ModuleTargetFollower extends Node2D

@onready var entity = get_parent()
@export var map_data : MapData
@export var repeller : ModuleRepeller

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

var target := Vector2.ZERO
var starting_target := Vector2.ZERO
var repositions : Array[float] = []

@onready var sprite_home : Sprite2D = $SpriteHome
@export var body : ModuleBody

const MOVE_SPEED := 50.0

signal target_reached()

func activate() -> void:
	starting_target = global_position
	sprite_home.set_visible(false)
	if body: body.size_changed.connect(on_size_changed)

func on_size_changed(new_size : float) -> void:
	sprite_home.set_position(0.66 * Vector2.UP * new_size)
	sprite_home.set_scale(new_size / Global.config.sprite_size * Vector2.ONE)

# @TODO: a special type of tourist that repositions a few times, which would just cut the time between now and time_leave into bits
func generate_changes(time_now: float, time_leave:float) -> void:
	repositions.append(time_leave)

func _process(dt:float) -> void:
	move_to_target(dt)

func set_target(pos:Vector2) -> void:
	target = pos

func reset_target() -> void:
	target = Vector2.ZERO
	audio_player.stop()

func has_target() -> bool:
	return target.length() > 0.0003

func move_to_target(dt:float) -> void:
	if not has_target(): return
	
	var base_speed := Global.config.scale(Global.config.move_speed_tourist)
	
	var vec := (target - global_position).normalized()
	var new_pos = entity.get_position() + vec * base_speed * dt
	entity.set_position(new_pos)
	
	if not audio_player.playing:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	sprite_home.flip_h = vec.x < 0
	
	var dist := global_position.distance_to(target)
	var error_margin := 5 * base_speed * dt
	if dist <= error_margin:
		reach_target()
	
	# if we're inside the range of something that repels us
	# pick a new target outside of that range.
	var repel_center := repeller.get_repel_center(new_pos)
	if repel_center.length() > 0.003:
		repel(repel_center)

func reach_target() -> void:
	reset_target()
	target_reached.emit()

func leave() -> void:
	reset_to_starting_target()
	sprite_home.set_visible(true)

func reset_to_starting_target() -> void:
	target = starting_target

func reposition() -> void:
	repositions.pop_front()
	set_target(map_data.query_position())

func lure(pos:Vector2) -> void:
	set_target(pos)

func repel(pos:Vector2) -> void:
	var final_pos := repeller.get_repel_pos_within_bounds(pos)
	set_target(final_pos)

func is_done() -> bool:
	return repositions.size() <= 1

func get_next_change_time() -> float:
	return repositions.front()

func instant_move_to(pos:Vector2) -> void:
	starting_target = Vector2(0, pos.y)
	entity.set_position(pos)
	reach_target()
