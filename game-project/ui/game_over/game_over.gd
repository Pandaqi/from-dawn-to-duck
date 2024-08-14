class_name GameOver extends Node2D

@onready var restart_btn := $Container/Buttons/HBoxContainer/Restart
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var active := false

func activate() -> void:
	GSignal.game_over.connect(on_game_over)
	set_visible(false)

func on_game_over(we_won:bool) -> void:
	get_tree().paused = true
	
	set_visible(true)
	anim_player.play("appear")
	
	var vp_size := get_viewport_rect().size
	set_position(0.5 * vp_size)
	
	var match_scale : float = min(vp_size.x / 1280.0, vp_size.y / 720.0)
	if match_scale < 1.0:
		set_scale(Vector2.ONE * match_scale)
	
	await anim_player.animation_finished
	
	restart_btn.grab_focus()
	active = true

func _on_restart_pressed() -> void:
	if not active: return
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_pressed() -> void:
	if not active: return
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game_loop/menu/menu.tscn")
