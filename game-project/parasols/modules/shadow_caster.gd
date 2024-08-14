class_name ModuleShadowCaster extends Node2D

@export var poly : Array[Vector2] = []
@export var poly_uvs : Array[Vector2] = []
@export var shadows : Array[Shadow] = []
@onready var entity = get_parent()

var shape : ParasolShape
var scale_factor := Vector2.ONE

signal shape_changed(shape:ParasolShape, polygon:Array[Vector2])

func _ready() -> void:
	material = material.duplicate(false)

func set_color(c:Color) -> void:
	# @NOTE: color1 is just the white or some other neutral
	material.set_shader_parameter("color2", c)

func set_shape(shp:ParasolShape) -> void:
	shape = shp

	var random_scale := Vector2(
		Global.config.shape_scale_bounds.rand_float(),
		Global.config.shape_scale_bounds.rand_float(), 
	)
	
	scale_shape(random_scale)
	
func scale_shape(factor:Vector2) -> void:
	scale_factor *= factor
	
	var points := shape.get_points()
	poly = []
	poly_uvs = []
	for point in points:
		var final_point := Global.config.scale_vector(point) * factor
		poly.append(final_point)
		poly_uvs.append(0.5 * (point + Vector2.ONE))
	
	shape_changed.emit(shape, poly)
	
	var avg_scale := 0.5 * (scale_factor.x + scale_factor.y)
	material.set_shader_parameter("scale", 5 * avg_scale)

func get_polygon_local() -> Array[Vector2]:
	return poly.duplicate()

func get_polygon_global() -> Array[Vector2]:
	var arr : Array[Vector2] = []
	for point in poly:
		arr.append(to_global(point))
	return arr

func is_valid() -> bool:
	return poly.size() >= 3

func update_rotation(dr:float) -> void:
	set_rotation( get_rotation() + dr )
	queue_redraw()

func _process(_dt:float) -> void:
	cast_shadows()

func cast_shadows() -> void:
	if not is_valid(): return
	
	for shadow in shadows:
		shadow.reset()
	
	var points := get_polygon_global()
	var lights := get_tree().get_nodes_in_group("LightSources")
	for i in range(lights.size()):
		var light : ModuleLightSource = lights[i]
		if not light.enabled: continue
		
		# reuse existing shadows if possible
		var shadow : Shadow
		if i < shadows.size():
			shadow = shadows[i]
			shadow.active = true
		else:
			shadow = Shadow.new()
			shadows.append(shadow)
			entity.add_child(shadow)
		
		# extend points from sun direction
		for point in points:
			var ray := light.get_shadow_dir(point)
			var light_dist := light.get_shadow_distance(point)
			shadow.add_point_raw(point)
			shadow.add_point_raw(point + ray * light_dist)

		# make it one nice polygon in the right order
		shadow.finalize()
	
	queue_redraw()

func _draw() -> void:
	if not is_valid(): return
	for shadow in shadows:
		shadow.update()
	
	draw_polygon(poly, [Color(1,1,1)], poly_uvs)
