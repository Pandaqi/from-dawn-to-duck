class_name TutorialSprite extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

signal done()
signal died(t:TutorialSprite)

func set_stage(t:TutorialStage, speed:float = 1.0) -> void:
	var skip_pregame := OS.is_debug_build() and Global.config.skip_pregame
	if skip_pregame:
		await get_tree().process_frame
		kill()
		return
	
	sprite.set_frame(t.frame)
	anim_player.speed_scale = speed
	anim_player.play("fade_in")
	await anim_player.animation_finished
	await get_tree().create_timer(Global.config.tutorial_sprite_delay_time / speed).timeout
	done.emit()
	
	await get_tree().create_timer(Global.config.tutorial_sprite_stay_time / speed).timeout
	anim_player.play_backwards("fade_in")
	await anim_player.animation_finished
	kill()

func kill() -> void:
	self.queue_free()
	died.emit(self)
