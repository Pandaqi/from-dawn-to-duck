class_name AreaDrawer extends Node2D

var area : MapArea

@export var color := Color(1,1,1)

func update(a:MapArea) -> void:
	area = a
	queue_redraw()

func _draw() -> void:
	if not area: return
	draw_polygon(area.points, [color], area.uvs)
