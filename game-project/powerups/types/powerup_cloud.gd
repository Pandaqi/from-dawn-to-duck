extends PowerupType
class_name PowerupCloud

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	if invert:
		var clouds := pe.get_tree().get_nodes_in_group("Clouds")
		if clouds.size() <= 0: return true
		
		clouds.pick_random().kill()
		GSignal.feedback.emit(pe.global_position, "Cloud Begone!")
		return true
	
	pe.weather_data.spawner.add_event(pe.prog_data.time)
	GSignal.feedback.emit(pe.global_position, "Come Cloud!")
	return true
