class_name Parasols extends MainSystem

@export var parasol_scene : PackedScene
@export var map : Map
@export var parasols_data : ParasolsData
@export var prog_data : ProgressionData
@export var powerups_data : PowerupsData
@export var shop_type : PowerupType

func activate() -> void:
	prog_data.day_started.connect(on_day_started)
	prog_data.life_lost.connect(on_life_lost)
	GSignal.spawn_parasol.connect(on_spawn_requested)
	
	# if parasols are not enabled, we start with all of them already in the level 
	# (as none can be bought/grabbed/added over time)
	var num := Global.config.parasols_starting_num
	if not enabled: num = 5
	spawn_multiple(num)

func on_day_started() -> void:
	auto_buy_parasols_if_needed()

func auto_buy_parasols_if_needed() -> void:
	if not powerups_data.enabled: return
	if powerups_data.has_of_type(shop_type): return
	if prog_data.day % Global.config.parasols_auto_spawn_interval != 0: return
	spawn_multiple(Global.config.parasols_auto_spawn_per_day)

func on_life_lost() -> void:
	if Global.config.life_lost_means_parasol_lost:
		despawn_random()

func spawn_multiple(num:int) -> void:
	for i in range(num):
		spawn()

func spawn() -> void:
	var p : Parasol = parasol_scene.instantiate()
	var rand_pos := get_random_valid_position()
	p.set_position( rand_pos)
	map.layers.add_to_layer("parasols", p)
	p.activate()
	
	var rand_shape : ParasolShape = parasols_data.all_shapes.pick_random()
	p.set_shape(rand_shape)

func despawn_random() -> void:
	var list := get_all()
	if list.size() <= 1: return
	list.pick_random().kill()

func get_all() -> Array[Node]:
	return get_tree().get_nodes_in_group("Parasols")

func get_random_valid_position() -> Vector2:
	return map.map_data.query_position({ 
		"avoid": get_all(),
		"area": "beach",
		"dist": Global.config.parasols_min_spawn_dist
	})

func on_spawn_requested(add:bool) -> void:
	if add: spawn()
	else: despawn_random()
