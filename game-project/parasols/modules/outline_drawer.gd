class_name OutlineDrawer extends Node2D

var polygon : Array[Vector2]
var color : Color
var enabled := false

func update(poly:Array[Vector2], col:Color) -> void:
	polygon = poly
	polygon.append(polygon.front()) # make sure we close ourselves
	color = col
	queue_redraw()

func _draw() -> void:
	if not enabled: return
	var line_width := Global.config.scale(Global.config.parasol_outline_width)
	var final_color := color.darkened( Global.config.parasol_outline_color_darken )
	draw_polyline(polygon, final_color, line_width, false)
