extends PowerupType
class_name PowerupCoin

func execute(pe:ModulePowerupExecuter, _dt:float) -> bool:
	var reward := int(round(Global.config.powerup_coin_reward.rand_float() * Global.config.base_price))
	reward = max(reward, 1)
	pe.prog_data.change_coins(reward)
	GSignal.feedback.emit(pe.global_position, "+" + str(reward) + " coins!")
	return true
