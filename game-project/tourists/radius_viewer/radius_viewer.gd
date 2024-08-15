class_name RadiusViewer extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

var base_scale : Vector2
var base_color : Color = Color(117/255.0, 64/255.0, 14/255.0)

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	anim_player.play("fade_in_out")

func set_radius(r:float) -> void:
	var base_scale := 2.0 * r / Global.config.sprite_size * Vector2.ONE
	sprite.set_scale(base_scale)

func animate_flash() -> void:
	var tw := get_tree().create_tween()
	var dur := 0.075
	tw.tween_property(sprite, "scale", 1.1*base_scale, dur)
	tw.parallel().tween_property(sprite, "material:shader_parameter/color", Color(1,0,0), dur)
	tw.tween_property(sprite, "scale", base_scale, dur)
	tw.parallel().tween_property(sprite, "material:shader_parameter/color", base_color, dur)
