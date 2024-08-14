class_name PowerupTutorials extends Node2D

var nodes : Array[Node2D] = []
var types_covered : Array[PowerupType] = []
var possible_spawn_points : Array[Vector2] = []

@export var powerups_data : PowerupsData
@export var map : Map

@export var powerup_tutorial_scene : PackedScene

func activate() -> void:
	powerups_data.powerup_added.connect(on_powerup_added)
	powerups_data.powerup_removed.connect(on_powerup_removed)
	possible_spawn_points = map.map_data.tree_line.get_points_within_bounds(map.map_data.bounds, 3*Global.config.sprite_size)

func on_powerup_added(p:Powerup) -> void:
	if types_covered.has(p.type): return
	add_for_type(p.type)

func on_powerup_removed(p:Powerup) -> void:
	if powerups_data.has_of_type(p.type): return
	remove_for_type(p.type)

func add_for_type(tp:PowerupType) -> void:
	var p = powerup_tutorial_scene.instantiate()
	
	var rand_pos := map.map_data.query_position({
		"points": possible_spawn_points,
		"avoid": nodes,
		"dist": Global.config.scale(Global.config.powerups_tutorials_min_dist)
	})
	p.set_position(rand_pos)
	map.layers.add_to_layer("floor", p)
	p.set_type(tp)
	
	# The tutorial sprite is 512x512, but only half of it is filled by the actual sprite, so that the base sprite size is essentially still 256
	# @NOTE: the 0.85 is just to shrink them a tiny bit, to prevent hugging the edge which looks ugly
	var target_size := map.map_data.get_beach_y()
	p.set_scale(target_size / Global.config.sprite_size * Vector2.ONE * 0.85)

func remove_for_type(tp:PowerupType) -> void:
	for node in nodes:
		if node.type != tp: continue
		nodes.erase(node)
		types_covered.erase(tp)
		node.queue_free()
		break
