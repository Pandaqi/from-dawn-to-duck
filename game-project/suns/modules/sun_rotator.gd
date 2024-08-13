class_name ModuleSunRotator extends Node2D

@export var prog_data : ProgressionData

@onready var entity = get_parent()

@export var arc_center := Vector2.ZERO
@export var arc_radius := 10.0
@export var auto_arc := false
@export var cur_arc_ratio := 0.0 # 0.0 is left (dawn), 1.0 is right (dusk)
@export var speed_scale := 1.0
@export var move_with_mouse := false

signal arc_started()
signal arc_ended()

func activate() -> void:
	prog_data.day_started.connect(reset)

func reset() -> void:
	cur_arc_ratio = 0
	arc_started.emit()

func _process(dt:float) -> void:
	move_in_arc(dt)
	point_sun_at_beach()

func set_arc_data(c:Vector2, r:float) -> void:
	arc_center = c
	arc_radius = r

func get_arc_angle() -> float:
	return PI + cur_arc_ratio * PI

func move_in_arc(dt) -> void:
	if auto_arc:
		cur_arc_ratio = clamp(cur_arc_ratio + speed_scale * dt, 0.0, 1.0)
	else:
		cur_arc_ratio = prog_data.time
	
	var pos := arc_center + Vector2.from_angle(get_arc_angle()) * arc_radius
	entity.set_position(pos)
	
	if cur_arc_ratio >= 1.0:
		arc_ended.emit()

func point_sun_at_beach() -> void:
	var target_point := arc_center
	var angle := (target_point - global_position).angle()
	entity.set_rotation(angle)

func _input(ev:InputEvent) -> void:
	if move_with_mouse and (ev is InputEventMouseMotion):
		entity.set_position(ev.position)
