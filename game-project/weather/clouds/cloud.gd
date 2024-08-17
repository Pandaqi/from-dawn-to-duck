class_name Cloud extends Node2D

@export var prog_data : ProgressionData

@onready var sprite : Sprite2D = $Sprite2D

var start_pos : Vector2
var end_pos : Vector2
var time_start : float
var time_leave : float
var speed := 1.0
var is_blocking_light := false

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

func _process(_dt:float) -> void:
	var frac := (prog_data.time - time_start) / (time_leave - time_start)
	var new_pos := start_pos.lerp(end_pos, frac)
	set_position(new_pos)
	
	var mod_col := Color(2,2,2,2) if is_blocking_light else Color(1,1,1,Global.config.cloud_alpha)
	modulate = mod_col
	
	var reached_end_pos := frac >= 1.0
	if reached_end_pos:
		kill()

func get_collider_line() -> Line:
	return line.clone().move(get_position())

func kill() -> void:
	died.emit(self)
	
	var old_pos := get_position()
	var tw := get_tree().create_tween()
	tw.tween_property(self, "scale", Vector2.ONE*1.25, 0.075)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.15)
	tw.parallel().tween_property(self, "position", old_pos + Vector2.DOWN*3.75*Global.config.sprite_size, 0.2)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	await tw.finished
	
	self.queue_free()
