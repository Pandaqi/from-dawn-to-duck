extends PowerupType
class_name PowerupRepel

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	GSignal.feedback.emit(pe.global_position, "Shoo! Shoo!")
	for player in pe.players_here:
		player.tourist_lure.repel()
	return true
