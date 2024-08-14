class_name ModuleVisualsTourist extends Node2D

@export var body : ModuleBody
@onready var sprite : Sprite2D = $Sprite2D

func activate() -> void:
	body.size_changed.connect(on_size_changed)

func on_size_changed(s:float) -> void:
	sprite.set_scale(Vector2.ONE * s / Global.config.sprite_size)
