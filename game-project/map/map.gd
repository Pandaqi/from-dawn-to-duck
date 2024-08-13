class_name Map extends Node2D

@onready var layers : MapLayers = $MapLayers
@export var map_data : MapData

@onready var bg_node := $BG
@onready var beach_node := $Beach
@onready var water_node := $Water

func activate() -> void:
	var size := Global.config.scale_vector(Global.config.map_size)
	map_data.set_bounds(Rect2(0, 0, size.x, size.y))
	
	map_data.generate()
	
	bg_node.update(map_data.areas.trees)
	beach_node.update(map_data.areas.beach)
	water_node.update(map_data.areas.water)
