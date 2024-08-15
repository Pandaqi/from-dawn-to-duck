class_name ModuleShadowCaster extends Node2D

@export var poly : Array[Vector2] = []
@export var poly_uvs : Array[Vector2] = []
@export var shadows : Array[Shadow] = []
@onready var entity = get_parent()
@onready var outline_drawer : OutlineDrawer = $OutlineDrawer

var shape : ParasolShape
var color : Color
var scale_factor := Vector2.ONE

var locked := false
var last_light_dir : Vector2
var last_light_dist : float

signal shape_changed(shape:ParasolShape, polygon:Array[Vector2])

func _ready() -> void:
	material = material.duplicate(false)

func set_locked(val:bool) -> void:
	locked = val

func set_color(c:Color) -> void:
	# @NOTE: color1 is just the white or some other neutral
	color = c
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

# @TODO: can I cache this somehow, to prevent LOADS of extra calculations by making this global array every frame?
func get_polygon_global() -> Array[Vector2]:
	var arr : Array[Vector2] = []
	for point in poly:
		arr.append(to_global(point))
	return arr

func is_valid() -> bool:
	return poly.size() >= 3

func contains(pos:Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(pos, get_polygon_global())

func update_rotation(dr:float) -> void:
	set_rotation( get_rotation() + dr )
	queue_redraw()

func _process(dt:float) -> void:
	cast_shadows()
	reveal_entities_below(dt)

func cast_shadows() -> void:
	if not is_valid(): return
	
	for shadow in shadows:
		shadow.reset()
	
	var points := get_polygon_global()
	var lights := get_tree().get_nodes_in_group("LightSources")
	
	var new_dir : Vector2
	var new_dist : float
	
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
			var ray := last_light_dir if locked else light.get_shadow_dir(point)
			var light_dist := last_light_dist if locked else light.get_shadow_distance(point)
			
			new_dir = ray
			new_dist = light_dist
			
			shadow.add_point_raw(point)
			shadow.add_point_raw(point + ray * light_dist)

		# make it one nice polygon in the right order
		shadow.finalize()
	
	outline_drawer.enabled = entity.is_held()
	outline_drawer.update(get_polygon_local(), color)
	
	if not locked:
		last_light_dir = new_dir
		last_light_dist = new_dist
	
	queue_redraw()

func reveal_entities_below(dt:float) -> void:
	var entities := get_tree().get_nodes_in_group("Entities")
	var should_fade := false
	for other_entity in entities:
		if not self.contains(other_entity.global_position): continue
		should_fade = true
	
	var target_alpha := Global.config.parasol_alpha_reveal_behind if should_fade else 1.0
	var current_alpha : float = material.get_shader_parameter("alpha")
	var smooth_alpha : float = lerp(current_alpha, target_alpha, 3.0*dt)
	material.set_shader_parameter("alpha", smooth_alpha)

func _draw() -> void:
	if not is_valid(): return
	for shadow in shadows:
		shadow.update()
	
	# draw the actual parasol head/top shape
	# (color irrelevant; shader will overrule it later)
	draw_polygon(poly, [Color(1,1,1)], poly_uvs)
