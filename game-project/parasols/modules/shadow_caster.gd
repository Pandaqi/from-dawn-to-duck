class_name ModuleShadowCaster extends Node2D

@export var poly : Array[Vector2] = []
@export var shadows : Array[Shadow] = []

func get_polygon_local() -> Array[Vector2]:
	return poly.duplicate()

func get_polygon_global() -> Array[Vector2]:
	var arr : Array[Vector2] = []
	for point in poly:
		arr.append(global_position + point)
	return arr

func is_valid() -> bool:
	return poly.size() >= 3

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
			get_tree().get_root().add_child(shadow)
		
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
	
	draw_polygon(poly, [Color(1,0,0)])
