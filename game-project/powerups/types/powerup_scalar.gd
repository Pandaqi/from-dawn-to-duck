extends PowerupType
class_name PowerupScalar

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var scale_factor := Global.config.powerup_scalar_scale_factor
	# some variation in scaling between X and Y
	var scale_vec := Vector2(1.0 + 0.25*randf(), 1.0 + 0.25*randf()) * scale_factor
	
	var msg := "Supersize!"
	if invert:
		scale_vec = Vector2(1.0 / scale_vec.x, 1.0 / scale_vec.y)
		msg = "Tinify!"
	
	for player in pe.players_here:
		var pg : ModuleParasolGrabber = player.parasol_grabber
		if not pg.has_parasol(): continue
		pg.parasol.shadow_caster.scale_shape(scale_vec)
		GSignal.feedback.emit(pe.global_position, msg)
	return true
