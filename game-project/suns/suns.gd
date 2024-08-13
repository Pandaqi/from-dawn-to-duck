class_name Suns extends MainSystem

@export var sun_scene : PackedScene
@export var map : Map

func activate() -> void:
	if enabled: spawn()

func spawn() -> void:
	var s : Sun = sun_scene.instantiate()
	
	add_child(s)
	s.activate()
	
	var bds := map.map_data.get_bounds()
	s.sun_rotator.set_arc_data(0.5 * bds.size, 0.5 * bds.size.x)
