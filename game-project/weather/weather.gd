class_name Weather extends MainSystem

@export var weather_data : WeatherData
@export var prog_data : ProgressionData
@export var sun_scene : PackedScene
@export var map : Map

@export var cloud_scene : PackedScene
var spawner_clouds : SpawnerClouds

func activate() -> void:
	weather_data.reset()
	prog_data.day_started.connect(on_day_started)
	spawner_clouds = SpawnerClouds.new()
	weather_data.spawner = spawner_clouds
	if enabled: spawn_sun()

func on_day_started() -> void:
	weather_data.reset_for_day()
	
	# @TODO: is this the best place? Or should this be on WeatherData itself?
	# the amount of variance/extremes in heat grow by day
	var variation_raw := Global.config.weather_variation + Global.config.weather_variation_increase_per_day * prog_data.day
	var variation_clamped : float = clamp(variation_raw, 0.0, 1.0)
	weather_data.weather_variation = variation_clamped

	# only pick from the heat_bound values that fit within our current variance
	var min_frac := 1.0 - randf() * variation_clamped
	var max_frac := randf() * variation_clamped

	weather_data.heat_bounds = Bounds.new(
		Global.config.heat_bounds_min.interpolate(min_frac),
		Global.config.heat_bounds_max.interpolate(max_frac)
	)
	
	spawner_clouds.generate()

func _process(_dt:float) -> void:
	update_heat()
	update_clouds()
	spawn_clouds_if_needed()

func update_clouds() -> void:
	var is_cloudy := get_active_lights().size() <= 0
	weather_data.set_cloudy(is_cloudy)

func update_heat() -> void:
	weather_data.update_heat(prog_data.get_time_symmetric())

func spawn_clouds_if_needed() -> void:
	var ev := spawner_clouds.update(prog_data)
	if not ev: return
	spawn_cloud(ev)

func spawn_sun() -> void:
	var s : Sun = sun_scene.instantiate()
	
	add_child(s)
	s.activate()
	
	var bds := map.map_data.get_bounds()
	s.sun_rotator.set_arc_data(0.5 * bds.size, 0.5 * bds.size.x)

func spawn_cloud(ev:SpawnEvent) -> void:
	var c : Cloud = cloud_scene.instantiate()
	var bds := map.map_data.get_bounds()
	var cloud_y := bds.position.y + Global.config.cloud_y.rand_float() * bds.size.y
	var start_pos := Vector2(bds.position.x + bds.size.x, cloud_y)
	var end_pos := Vector2(bds.position.x, cloud_y)
	
	# @TODO: some fade/popup animation for its appearance and disappearance?
	c.set_position(start_pos)
	add_child(c)
	c.activate(end_pos, ev.time_leave)

func get_active_lights() -> Array[ModuleLightSource]:
	var arr : Array[ModuleLightSource] = []
	for node in get_tree().get_nodes_in_group("LightSources"):
		if not node.enabled: continue
		arr.append(node)
	return arr
