class_name ModuleVisualsPowerup extends Node2D

@onready var bg : Sprite2D = $BG
@onready var icon : Sprite2D = $Icon
@onready var price_cont : Node2D = $Price
@onready var price_label : Label = $Price/Label

func activate(type:PowerupType, radius:float) -> void:
	icon.set_frame(type.frame)
	
	bg.material = bg.material.duplicate(false)
	bg.material.set_shader_parameter("color", type.color)
	bg.set_scale(Vector2.ONE * 2 * radius / Global.config.sprite_size)
	bg.scale.y *= Global.config.y_squash_factor
	
	# this is just for some cheap visual differentiation 
	bg.flip_h = randf() <= 0.5
	bg.flip_v = randf() <= 0.5

	# display price if needed
	var price : int = type.get_cost()
	price_cont.set_visible(price > 0)
	price_label.set_text(str(price))
	
	# scale everything accordingly
	var min_size := Global.config.powerups_radius_bounds.start
	icon.set_scale(Vector2.ONE * 2 * min_size)
	price_cont.set_scale(Vector2.ONE * 0.75 * min_size)
	price_cont.position.y = 0.66 * Global.config.sprite_size * price_cont.scale.y
