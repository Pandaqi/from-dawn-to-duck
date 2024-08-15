extends PowerupType
class_name PowerupRepel

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	if invert:
		for player in pe.players_here:
			player.tourist_lure.lure()
		return false
	
	for player in pe.players_here:
		player.tourist_lure.repel()
	return true
