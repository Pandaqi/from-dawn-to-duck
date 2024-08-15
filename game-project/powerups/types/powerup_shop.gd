extends PowerupType
class_name PowerupShop

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	if invert:
		GSignal.spawn_parasol.emit(false)
		GSignal.feedback.emit(pe.global_position, "Remove Parasol!")
		return true
	
	GSignal.feedback.emit(pe.global_position, "New Parasol!")
	GSignal.spawn_parasol.emit(true)
	return true
