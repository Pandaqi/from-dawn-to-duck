class_name Tourists extends MainSystem

@export var tourist_scene : PackedScene
@export var map : Map
@export var prog_data : ProgressionData
var spawner : Spawner

func activate() -> void:
	spawner = Spawner.new()
	prog_data.day_started.connect(on_day_started)

func on_day_started() -> void:
	spawner.regenerate(prog_data)

func _process(_dt:float) -> void:
	var ev := spawner.update(prog_data)
	if not ev: return
	spawn(ev)

func spawn(ev:SpawnEvent) -> void:
	var t : Tourist = tourist_scene.instantiate()
	var pos := get_random_valid_position()
	map.layers.add_to_layer("entities", t)
	
	# if not enabled, the people just spawn right at some random location
	# otherwise, that becomes their _target_, but they spawn off screen
	if enabled:
		var pos_off := map.map_data.get_random_position_off_screen()
		t.set_position( Vector2(pos_off.x, pos.y) )
		t.target_follower.set_target(pos)

	t.state_tourist.spawn_event = ev
	
	t.activate()
	
	if not enabled:
		t.target_follower.instant_move_to(pos)

func get_all() -> Array[Node]:
	return get_tree().get_nodes_in_group("Tourists")

func count() -> int:
	return get_all().size()

func get_random_valid_position() -> Vector2:
	return map.map_data.query_position({ 
		"avoid": get_all(),
		"area": "beach",
		"area_margin": 1.5*Global.config.sprite_size,
		"dist": Global.config.tourists_min_spawn_dist
	})

func can_end_day() -> bool:
	var no_tourists_left := count() <= 0
	return no_tourists_left and not spawner.has_events()
