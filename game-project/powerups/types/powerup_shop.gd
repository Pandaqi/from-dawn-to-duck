extends PowerupType
class_name PowerupShop

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	GSignal.feedback.emit(pe.global_position, "New Parasol!")
	GSignal.spawn_parasol.emit()
	return true
