class_name Map extends Node2D

@onready var layers : MapLayers = $MapLayers
@export var map_data : MapData

func activate():
	# @TODO: properly calculate this based on beach created
	var size := Global.config.scale_vector(Global.config.map_size)
	map_data.set_bounds(Rect2(0, 0, size.x, size.y))
