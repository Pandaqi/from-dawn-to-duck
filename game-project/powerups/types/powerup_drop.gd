extends PowerupType
class_name PowerupDrop

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	for player in pe.players_here:
		if not player.parasol_grabber.has_parasol(): continue
		player.parasol_grabber.drop()
		GSignal.feedback.emit(pe.global_position, "Dropped!")
	return true
