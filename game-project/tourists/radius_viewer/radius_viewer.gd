class_name RadiusViewer extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	anim_player.play("fade_in_out")

func set_radius(r:float) -> void:
	sprite.set_scale(2.0 * r / Global.config.sprite_size * Vector2.ONE)
