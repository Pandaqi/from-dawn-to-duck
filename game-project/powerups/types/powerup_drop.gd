extends PowerupType
class_name PowerupDrop

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	for player in pe.players_here:
		player.parasol_grabber.drop()
	return true
