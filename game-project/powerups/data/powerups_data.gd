extends Resource
class_name PowerupsData

@export var all_powerups : Array[PowerupType] = []
var powerups : Array[Powerup] = []

signal powerup_added(p:Powerup)
signal powerup_removed(p:Powerup)

func reset() -> void:
	powerups = []

func add_powerup(ps:Powerup) -> void:
	powerups.append(ps)
	powerup_added.emit(ps)

func remove_powerup(ps:Powerup) -> void:
	powerups.erase(ps)
	powerup_removed.emit(ps)

func count() -> int:
	return powerups.size()

# @TODO: actually track those powerup nodes being created/destroyed
func get_of_type(tp:PowerupType) -> Array[Powerup]:
	var arr : Array[Powerup] = []
	for p in powerups:
		if p.type != tp: continue
		arr.append(p)
	return arr

func has_of_type(tp:PowerupType) -> bool:
	return get_of_type(tp).size() > 0
