class_name ModuleMapTracker extends Node2D

@export var map_data : MapData

func on_beach() -> bool:
	return map_data.areas.beach.contains(global_position)

func on_water() -> bool:
	return map_data.areas.water.contains(global_position)
