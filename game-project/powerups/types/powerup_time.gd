extends PowerupType
class_name PowerupTime

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var change := Global.config.powerups_time_scale_factor
	var msg := "Time Flies!"
	if invert: 
		change = 1.0 / change
		msg = "Slow it down!"
	
	pe.weather_data.change_time_scale(change)
	GSignal.feedback.emit(pe.global_position, msg)
	return true
