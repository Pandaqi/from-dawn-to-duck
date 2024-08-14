extends PowerupType
class_name PowerupLife

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	GSignal.feedback.emit(pe.global_position, "+1 Life!")
	pe.prog_data.change_lives(+1)
	return true
