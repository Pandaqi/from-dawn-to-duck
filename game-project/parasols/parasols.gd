class_name Parasols extends MainSystem

@export var parasol_scene : PackedScene
@export var map : Map

func activate() -> void:
	
	# if parasols are not enabled, we start with all of them already in the level 
	# (as none can be bought/grabbed/added over time)
	var num := 2
	if not enabled: num = 5
	spawn_multiple(num)

func spawn_multiple(num:int) -> void:
	for i in range(num):
		spawn()

func spawn() -> void:
	var p : Parasol = parasol_scene.instantiate()
	var rand_pos := get_random_valid_position()
	p.set_position( rand_pos)
	map.layers.add_to_layer("entities", p)

func get_random_valid_position() -> Vector2:
	return map.map_data.query_position({ 
		"avoid": get_tree().get_nodes_in_group("Parasols"),
		"dist": 150.0
	})
		
