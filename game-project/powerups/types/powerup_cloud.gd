extends PowerupType
class_name PowerupCloud

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	if invert:
		var clouds := pe.get_tree().get_nodes_in_group("Clouds")
		for cloud in clouds:
			cloud.kill()
		GSignal.feedback.emit(pe.global_position, "Clouds Begone!")
		return true
	
	var num := Global.config.cloud_num_bounds.end + 1
	for i in range(num):
		pe.weather_data.spawner.add_event(pe.prog_data.time)
	GSignal.feedback.emit(pe.global_position, "Come Clouds!")
	return true
