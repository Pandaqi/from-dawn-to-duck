class_name AreaDrawer extends Node2D

var area : MapArea

@export var color := Color(1,1,1)

func update(a:MapArea) -> void:
	area = a
	queue_redraw()
	
	var bds := a.get_bounds()
	material.set_shader_parameter("pixel_size", bds.size)
	material.set_shader_parameter("tile_size", 3.0 * Global.config.sprite_size * Vector2.ONE)
	material.set_shader_parameter("falloff_dist", 0.5 * Global.config.sprite_size)
	material.set_shader_parameter("gradient_dist", 1.0 * Global.config.sprite_size)

func _draw() -> void:
	if not area: return
	draw_polygon(area.points, [color], area.uvs)
