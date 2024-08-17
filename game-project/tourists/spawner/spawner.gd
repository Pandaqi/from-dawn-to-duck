class_name Spawner

var events : Array[SpawnEvent] = []

func regenerate(prog_data:ProgressionData) -> void:
	events = []

	# first create all the events, spaced out evenly
	var num_events_from_day := Global.config.spawner_extra_tourists_per_day * prog_data.day
	var num_events := Global.config.spawner_starting_tourists
	num_events = int( round(num_events + num_events_from_day) )
	num_events = min(num_events, Global.config.spawner_max_tourists)
	
	for i in range(num_events):
		var time := i / float(num_events)
		events.append(SpawnEvent.new(time))
	
	# then randomly push and pull them, favoring a midday peak
	var random_steps_from_day := (Global.config.spawner_random_increase_per_day * prog_data.day)
	var random_steps := events.size() * (Global.config.spawner_random_steps_factor + random_steps_from_day)

	var offset_from_day := Global.config.spawner_random_offset_increase_per_day * prog_data.day
	var offset_per_randomization := Global.config.spawner_random_offset_bounds.clone()
	offset_per_randomization.start = min(offset_per_randomization.start + offset_from_day, 0.5)
	offset_per_randomization.end = min(offset_per_randomization.end + offset_from_day, 0.5)
	
	var dur_bounds := Global.config.stay_duration_bounds.clone()
	var dur_add_from_day := Global.config.stay_duration_increase_per_day * prog_data.day
	dur_bounds.start = min(dur_bounds.start + dur_add_from_day, Global.config.stay_duration_max)
	dur_bounds.end = min(dur_bounds.end + dur_add_from_day, Global.config.stay_duration_max)

	for i in range(random_steps):
		var ev : SpawnEvent = events.pick_random()
		var dir := 1 if ev.time <= 0.5 else -1
		var new_time = ev.time + dir * offset_per_randomization.rand_float()
		new_time = clamp(new_time, 0.0, 1.0 - dur_bounds.start)
		ev.time = new_time
	
	# to make sure you're not just wasting time waiting at the start of a day
	# force a few events to spawn early
	var event_before := Global.config.spawner_must_have_event_before
	if event_before > 0.0:
		var num_events_before := Global.config.spawner_num_events_before
		for i in range(num_events_before):
			events.pick_random().time = randf() * event_before
	
	# give them a random duration, ensuring they never extend past the end of the day
	for ev in events:
		var max_dur : float = clamp(1.0 - ev.time, dur_bounds.start, dur_bounds.end)
		var final_dur : float = lerp(dur_bounds.start, max_dur, randf())
		if(dur_bounds.start >= max_dur): final_dur = max_dur
		ev.time = clamp(ev.time, 0.01, 0.99)
		ev.time_leave = clamp(ev.time + final_dur, 0.01, 0.99)
	
	# sort so that we only ever need to check the first one
	events.sort_custom(func(a:SpawnEvent, b:SpawnEvent):
		if a.time < b.time: return true
		return false
	)

func has_events() -> bool:
	return events.size() > 0

func update(prog_data:ProgressionData) -> SpawnEvent:
	if events.size() <= 0: return null
	var ev_first : SpawnEvent = events.front()
	if ev_first.time > prog_data.time: return null
	return events.pop_front()
