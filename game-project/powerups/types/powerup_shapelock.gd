extends PowerupType
class_name PowerupShapelock

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	for player in pe.players_here:
		var grabber := player.parasol_grabber
		if not grabber.has_parasol(): continue
		grabber.parasol.shadow_caster.set_locked(true)
		GSignal.feedback.emit(pe.global_position, "Shape Locked!")
	return true
