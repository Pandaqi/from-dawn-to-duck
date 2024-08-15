extends PowerupType
class_name PowerupHeat

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	var dhs := Global.config.powerup_heat_scale_factor
	pe.weather_data.change_heat_scale(dhs)
	GSignal.feedback.emit(pe.global_position, "Cool it down!")
	return true
