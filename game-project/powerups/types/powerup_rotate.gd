extends PowerupType
class_name PowerupRotate

func execute(pe:ModulePowerupExecuter, dt:float, invert := false) -> bool:
	var dir := -1 if invert else 1
	for player in pe.players_here:
		player.parasol_grabber.rotate_parasol(dir * dt)
	return true
