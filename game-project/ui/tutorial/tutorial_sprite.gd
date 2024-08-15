class_name TutorialSprite extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

signal done()

func set_stage(t:TutorialStage) -> void:
	sprite.set_frame(t.frame)
	anim_player.play("fade_in")
	await anim_player.animation_finished
	await get_tree().create_timer(Global.config.tutorial_sprite_delay_time).timeout
	done.emit()
	
	await get_tree().create_timer(Global.config.tutorial_sprite_stay_time).timeout
	anim_player.play_backwards("fade_in")
	await anim_player.animation_finished
	self.queue_free()
