class_name Weather extends MainSystem

@export var weather_data : WeatherData
@export var prog_data : ProgressionData
@export var sun_scene : PackedScene
@export var map : Map

func activate() -> void:
	weather_data.reset()
	prog_data.day_started.connect(on_day_started)
	if enabled: spawn_sun()

func on_day_started() -> void:
	weather_data.reset_for_day()

func spawn_sun() -> void:
	var s : Sun = sun_scene.instantiate()
	
	add_child(s)
	s.activate()
	
	var bds := map.map_data.get_bounds()
	s.sun_rotator.set_arc_data(0.5 * bds.size, 0.5 * bds.size.x)
