extends PowerupType
class_name PowerupLure

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	GSignal.feedback.emit(pe.global_position, "Hey, come closer!")
	for player in pe.players_here:
		player.tourist_lure.lure()
	return true
