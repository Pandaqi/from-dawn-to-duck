class_name Powerups extends Node2D

@export var map : Map
@export var powerup_scene : PackedScene
@export var powerups_data : PowerupsData
@onready var timer : Timer = $Timer

@export var type_shop : PowerupType

@onready var tutorials : PowerupTutorials = $PowerupTutorials

func activate() -> void:
	tutorials.activate()
	powerups_data.reset()
	place_starting_powerups()
	
	timer.timeout.connect(on_timer_timeout)
	restart_timer()

func place_starting_powerups() -> void:
	spawn(type_shop)

func restart_timer() -> void:
	timer.wait_time = Global.config.powerup_spawn_tick * Global.config.day_duration
	timer.start()

func on_timer_timeout() -> void:
	refresh()

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
		"dist": Global.config.scale(Global.config.powerups_min_dist)
	})
	
	ps.set_position( rand_pos )
	map.layers.add_to_layer("floor", ps)

	var rand_type : PowerupType = powerups_data.all_powerups.pick_random()
	if type_forced: rand_type = type_forced
	ps.activate(rand_type)
	
	# @NOTE: must come after activation
	powerups_data.add_powerup(ps)
	ps.died.connect(func(_n): powerups_data.remove_powerup(ps))
