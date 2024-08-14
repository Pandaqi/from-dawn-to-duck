extends PowerupType
class_name PowerupTime

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	var change := Global.config.powerups_time_scale_factor
	pe.weather_data.change_time_scale(change)
	GSignal.feedback.emit(pe.global_position, "Time Flies!")
	return true
