class_name Parasol extends Node2D

@onready var handle := $Handle
@onready var shadow_caster : ModuleShadowCaster = $ShadowCaster

var shape : ParasolShape
var color : Color

func activate() -> void:
	pass

func get_handle_position() -> Vector2:
	return handle.global_position

func set_shape(shp:ParasolShape) -> void:
	shape = shp
	color = Global.config.parasol_colors.pick_random()
	
	shadow_caster.set_shape(shp)
	shadow_caster.set_color(color)
