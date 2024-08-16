extends Node2D

@export var squiggly_line : PackedScene
@onready var timer : Timer = $Timer
@onready var visuals : ModuleVisualsTourist = get_parent()
@export var shadow_tracker : ModuleShadowTracker

func activate() -> void:
	shadow_tracker.shadow_changed.connect(on_shadow_changed)
	timer.timeout.connect(spawn)

func on_shadow_changed(in_shadow:bool) -> void:
	if not in_shadow: start()
	else: stop()

func start() -> void:
	set_visible(true)
	spawn()

func spawn() -> void:
	var sl : SquigglyLine = squiggly_line.instantiate()
	var pos_around := visuals.get_pos_around()
	var angle : float = (pos_around - visuals.get_center_pos()).angle()
	sl.set_position(pos_around)
	sl.set_rotation(angle)
	sl.set_scale(Vector2.ONE * 0.75)
	add_child(sl)
	
	restart_timer()

func restart_timer() -> void:
	timer.stop()
	timer.wait_time = randf_range(0.1, 0.3)
	timer.start()

func stop_timer() -> void:
	timer.stop()

func stop() -> void:
	for child in get_children():
		if child is not SquigglyLine: continue
		child.queue_free()
	set_visible(false)
	stop_timer()
