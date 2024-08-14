class_name DayOver extends Node2D

var active := false
var edge_margin := 32.0

@onready var continue_btn := $Container/Button/Continue
@onready var anim_player : AnimationPlayer = $AnimationPlayer

signal dismissed()

func activate() -> void:
	set_visible(false)

func appear() -> void:
	set_visible(true)
	get_tree().paused = true
	
	var vp_size := get_viewport_rect().size
	set_position(0.5 * vp_size)
	
	var match_scale : float = min(
		(vp_size.x - 2*edge_margin) / 1280.0, 
		(vp_size.y - 2*edge_margin) / 720.0
	)
	if match_scale < 1.0:
		set_scale(Vector2.ONE * match_scale)
		
	anim_player.play("appear")
	await anim_player.animation_finished
	continue_btn.grab_focus()
	active = true

func dismiss() -> void:
	anim_player.play_backwards("appear")
	await anim_player.animation_finished
	get_tree().paused = false
	active = false
	dismissed.emit()
	set_visible(false)

func _on_continue_pressed() -> void:
	if not active: return
	dismiss()
