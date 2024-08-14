extends PowerupType
class_name PowerupRotate

func execute(pe:ModulePowerupExecuter, dt:float) -> bool:
	for player in pe.players_here:
		player.parasol_grabber.rotate_parasol(dt)
	return true
