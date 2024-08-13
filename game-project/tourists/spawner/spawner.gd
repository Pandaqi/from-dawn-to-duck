class_name Spawner

var events : Array[SpawnEvent] = []

func regenerate(prog_data:ProgressionData) -> void:
	events = []
	
	# @TODO: actually assign types, fill the day based on a target "cumulative strength", etcetera
	
	# first create all the events, spaced out evenly
	var num_events := 3 + prog_data.day
	for i in range(num_events):
		var time := i / float(num_events)
		events.append(SpawnEvent.new(time))
	
	# then randomly push and pull them, favoring a midday peak
	var random_steps := events.size() * Global.config.spawner_random_steps_factor
	var offset_per_randomization := Global.config.spawner_random_offset_max
	var dur_bounds := Global.config.stay_duration_bounds
	
	for i in range(random_steps):
		var ev : SpawnEvent = events.pick_random()
		var dir := 1 if ev.time <= 0.5 else -1
		var new_time = ev.time + dir * randf() * offset_per_randomization
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
		ev.time_leave = ev.time + final_dur
	
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
