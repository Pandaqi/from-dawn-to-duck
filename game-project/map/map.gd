class_name Map extends Node2D

@onready var layers : MapLayers = $MapLayers
@export var map_data : MapData
@export var tutorial : Tutorial

@onready var bg_node := $BG
@onready var beach_node := $Beach
@onready var water_node := $Water

@export var map_deco_scene : PackedScene

func activate() -> void:
	var size := Global.config.scale_vector(Global.config.map_size)
	map_data.set_bounds(Rect2(0, 0, size.x, size.y))
	
	tutorial.started.connect(on_tutorial_started)
	tutorial.done.connect(on_tutorial_done)
	
	map_data.generate()
	
	bg_node.update(map_data.areas.trees)
	beach_node.update(map_data.areas.beach)
	water_node.update(map_data.areas.water)
	
	place_bg_decorations()
	place_beach_decorations()

func on_tutorial_started() -> void:
	map_data.tutorial_active = true
	for node in get_tree().get_nodes_in_group("TutorialHideables"):
		node.set_visible(false)

func on_tutorial_done() -> void:
	map_data.tutorial_active = false
	for node in get_tree().get_nodes_in_group("TutorialHideables"):
		node.set_visible(true)
		play_pop_up_tween(node)

func place_bg_decorations() -> void:
	var num := 20

	# @NOTE: WHY do we manually calculate this instead of just asking map.areas.trees.get_random_position()
	# Because I am STUPID and originally put the map_deco_scene at the wrong origin (offset downwards), which is why I struggled for an HOUR wondering why things were positioned wrong, and ended up writing custom placement code to debug
	var bg_shrub_max_scale := 4.5
	var beach_line := Global.config.map_y_beach_line * map_data.bounds.size.y
	var displacement := Global.config.scale(Global.config.shore_line_displacement)
	var tree_y_bounds := Bounds.new(beach_line - 1.0*displacement, beach_line + 0.5*displacement)
	var tree_x_bounds := Bounds.new(map_data.bounds.position.x, map_data.bounds.position.x + map_data.bounds.size.x)
	
	for i in range(num):
		var node = map_deco_scene.instantiate()
		var x_pos := tree_x_bounds.interpolate((i + (randf() - 0.5)) / float(num))
		node.set_position(Vector2(x_pos, tree_y_bounds.rand_float()))
		
		# 0.0 if at the back, 1.0 if at the front
		var far_back_ratio : float = (node.position.y - tree_y_bounds.start) / (tree_y_bounds.end - tree_y_bounds.start)
		var modulate_factor : float = lerp(0.25, 1.0, far_back_ratio)
		var alpha : float = clamp(2.5 * modulate_factor, 0.0, 1.0)
		
		node.set_scale(Vector2.ONE * randf_range(0.5, 1.0) * bg_shrub_max_scale)
		node.set_rotation(randf_range(-1,1) * 0.025 * PI)
		node.get_node("Sprite2D").set_frame(4)
		node.get_node("Sprite2D").flip_h = randf() <= 0.5
		node.modulate = Color(modulate_factor, modulate_factor, modulate_factor, alpha)
		node.get_node("Shadow").set_visible(false)
		bg_node.add_child(node)
		play_pop_up_tween(node)

func place_beach_decorations() -> void:
	# the specks/dots into the sand floor
	var num_specks := 30
	for i in range(num_specks):
		var node = map_deco_scene.instantiate()
		node.set_position(map_data.areas.beach.get_random_position(Global.config.sprite_size))
		node.set_scale(Vector2.ONE * randf_range(0.25, 1.0))
		node.set_rotation(randf() * 2 * PI)
		node.get_node("Sprite2D").set_frame(0)
		node.get_node("Sprite2D").flip_h = randf() <= 0.5
		node.modulate.a = 0.5*randf_range(0.25, 1.0)
		node.get_node("Shadow").set_visible(false)
		beach_node.add_child(node)
		play_pop_up_tween(node)
	
	# some stones scattered around
	var num_stones := 18
	for i in range(num_stones):
		var node = map_deco_scene.instantiate()
		node.set_position(map_data.areas.beach.get_random_position(Global.config.sprite_size))
		node.set_scale(Vector2.ONE * randf_range(0.175, 0.725))
		node.set_rotation(randf_range(-1,1) * 0.01 * PI)
		node.get_node("Sprite2D").set_frame(randi_range(1,3))
		node.get_node("Sprite2D").flip_h = randf() <= 0.5
		node.add_to_group("TutorialHideables")
		layers.add_to_layer("entities", node)

func play_pop_up_tween(node:Node2D) -> void:
	
	var old_scale := node.scale
	var old_modulate := node.modulate.a
	node.set_scale(Vector2.ZERO)
	node.modulate.a = 0.0
	
	var tw := get_tree().create_tween()
	var dur := 0.33
	tw.tween_property(node, "scale", 1.2*old_scale, dur)
	tw.parallel().tween_property(node, "modulate:a", old_modulate, dur)
	tw.tween_property(node, "scale", old_scale, 2*dur)
