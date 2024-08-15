class_name SpawnerClouds

var events : Array[SpawnEvent] = []

func generate() -> void:
	events = []
	
	var num_clouds := Global.config.cloud_num_bounds.rand_int()
	var stay_dur_bounds := Global.config.cloud_stay_duration_bounds
	for i in range(num_clouds):
		var time_arrive : float = randf() * (1.0 - stay_dur_bounds.start)
		add_event(time_arrive)


func has_events() -> bool:
	return events.size() > 0

func add_event(time_arrive:float) -> void:
	var stay_dur_bounds := Global.config.cloud_stay_duration_bounds
	var time_leave : float =  min(time_arrive + stay_dur_bounds.rand_float(), 1.0)
	var ev = SpawnEvent.new(time_arrive, time_leave)
	events.append(ev)

	# sort so that we only ever need to check the first one
	events.sort_custom(func(a:SpawnEvent, b:SpawnEvent):
		if a.time < b.time: return true
		return false
	)

func update(prog_data:ProgressionData) -> SpawnEvent:
	if events.size() <= 0: return null
	var ev_first : SpawnEvent = events.front()
	if ev_first.time > prog_data.time: return null
	return events.pop_front()
