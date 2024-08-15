class_name Cloud extends Node2D

@export var prog_data : ProgressionData

@onready var sprite : Sprite2D = $Sprite2D

var start_pos : Vector2
var end_pos : Vector2
var time_start : float
var time_leave : float
var speed := 1.0

var line : Line

signal died(c:Cloud)

func activate(ep:Vector2, tml:float) -> void:
	start_pos = get_position()
	end_pos = ep
	time_start = prog_data.time
	time_leave = tml
	
	var size := Global.config.scale(Global.config.cloud_size_bounds.rand_float())
	
	sprite.set_scale(Vector2.ONE * size / Global.config.sprite_size)
	line = Line.new(
		Vector2(-0.5*size, 0),
		Vector2(0.5*size, 0)
	)
	
	modulate.a = Global.config.cloud_alpha

func _process(_dt:float) -> void:
	var frac := (prog_data.time - time_start) / (time_leave - time_start)
	var new_pos := start_pos.lerp(end_pos, frac)
	set_position(new_pos)
	
	var reached_end_pos := frac >= 1.0
	if reached_end_pos:
		kill()

func get_collider_line() -> Line:
	return line.clone().move(get_position())

# @TODO: death anim, wait for it to complete, etc
func kill() -> void:
	died.emit(self)
	self.queue_free()
