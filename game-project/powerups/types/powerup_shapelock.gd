extends PowerupType
class_name PowerupShapelock

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var lock_val := not invert
	var msg := "Shape Locker" if lock_val else "Shape Unlocked!"
	
	for player in pe.players_here:
		var grabber := player.parasol_grabber
		if not grabber.has_parasol(): continue
		grabber.parasol.shadow_caster.set_locked(lock_val)
		GSignal.feedback.emit(pe.global_position, msg)
	return true
