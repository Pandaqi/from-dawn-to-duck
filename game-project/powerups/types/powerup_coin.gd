extends PowerupType
class_name PowerupCoin

func execute(pe:ModulePowerupExecuter, _dt:float, invert := false) -> bool:
	var reward := int(round(Global.config.powerup_coin_reward.rand_float() * Global.config.base_price))
	reward = max(reward, 1)
	
	if invert:
		reward *= -1
	
	pe.prog_data.change_coins(reward)
	
	var reward_str := "+" + str(reward) if reward > 0 else str(reward)
	GSignal.feedback.emit(pe.global_position, reward_str + " coins!")
	return true
