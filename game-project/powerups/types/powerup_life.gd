extends PowerupType
class_name PowerupLife

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var reward := 1
	if invert: reward *= -1
	
	var reward_str := "+" + str(reward) if reward > 0 else str(reward)
	GSignal.feedback.emit(pe.global_position, reward_str + " Life!")
	pe.prog_data.change_lives(reward)
	return true
