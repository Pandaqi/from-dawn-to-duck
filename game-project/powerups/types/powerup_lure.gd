extends PowerupType
class_name PowerupLure

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	for player in pe.players_here:
		player.tourist_lure.lure()
	return true
