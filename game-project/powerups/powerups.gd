class_name Powerups extends MainSystem

@export var map : Map
@export var powerup_scene : PackedScene
@export var powerups_data : PowerupsData
@onready var timer : Timer = $Timer

@onready var tutorials : PowerupTutorials = $PowerupTutorials

func activate() -> void:
	tutorials.activate()
	powerups_data.reset()

	powerups_data.enable_changed.connect(on_enable_changed)
	timer.timeout.connect(on_timer_timeout)

func on_enable_changed(val:bool) -> void:
	if not val: 
		stop_timer()
		return
	
	place_starting_powerups()
	restart_timer()

func place_starting_powerups() -> void:
	if not enabled: return
	
	for type in powerups_data.all_powerups:
		var required_num := type.min_num
		if required_num <= 0: continue
		
		for i in range(required_num):
			spawn(type)

func restart_timer() -> void:
	if not enabled: return
	
	timer.wait_time = Global.config.powerup_spawn_tick * Global.config.day_duration
	timer.start()

func stop_timer() -> void:
	timer.stop()

func on_timer_timeout() -> void:
	refresh()
	restart_timer()

func get_all() -> Array[Node]:
	return get_tree().get_nodes_in_group("Powerups")

func refresh() -> void:
	# @TODO: scale with player count, map size, #days?
	var bounds := Global.config.powerup_spawn_bounds
	var nodes := get_all()
	var num := nodes.size()
	if num >= bounds.end: return
	
	while num < bounds.start:
		spawn()
		num += 1
	
	if randf() <= Global.config.powerup_spawn_prob and num < bounds.end:
		spawn()
		num += 1

func spawn(type_forced : PowerupType = null) -> void:
	var ps : Powerup = powerup_scene.instantiate()
	var rand_pos := map.map_data.query_position({
		"avoid": get_all(),
		"area": "beach",
		"area_margin": 2.0 * Global.config.sprite_size,
		"dist": Global.config.scale(Global.config.powerups_min_dist)
	})
	
	ps.set_position( rand_pos )
	map.layers.add_to_layer("floor", ps)

	var type_options := powerups_data.all_powerups.duplicate(false)
	type_options.shuffle()
	
	var rand_type : PowerupType
	for option in type_options:
		var count := powerups_data.get_of_type(option).size()
		if count > option.max_num: continue
		rand_type = option
		break
	
	if type_forced: rand_type = type_forced
	if not rand_type: rand_type = type_options.pick_random()
	ps.activate(rand_type)
	
	# @NOTE: must come after activation
	powerups_data.add_powerup(ps)
	ps.died.connect(func(_n): powerups_data.remove_powerup(ps))
