extends PowerupType
class_name PowerupLife

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	pe.prog_data.change_lives(+1)
	return true
