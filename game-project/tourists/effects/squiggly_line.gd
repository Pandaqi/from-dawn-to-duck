class_name SquigglyLine extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("burning_wiggle")
	await anim_player.animation_finished
	queue_free()
