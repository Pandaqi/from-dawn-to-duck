extends PowerupType
class_name PowerupCloud

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	pe.weather_data.spawner.add_event(pe.prog_data.time)
	GSignal.feedback.emit(pe.global_position, "Come Cloud!")
	return true
