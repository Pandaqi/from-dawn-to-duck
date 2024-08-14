extends PowerupType
class_name PowerupShop

func execute(_pe:ModulePowerupExecuter, _dt:float) -> bool:
	GSignal.spawn_parasol.emit()
	return true
