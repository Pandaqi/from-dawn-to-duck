extends PowerupType
class_name PowerupHeat

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var dhs := Global.config.powerup_heat_scale_factor
	if invert: 
		dhs = 1.0 / dhs
		GSignal.feedback.emit(pe.global_position, "Hotter and hotter!")
	else:
		GSignal.feedback.emit(pe.global_position, "Cool it down!")
	
	pe.weather_data.change_heat_scale(dhs)
	return true
