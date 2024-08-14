class_name Parasol extends Node2D

@onready var handle := $Handle
@onready var handle_sprite := $Handle/Sprite2D
@onready var shadow_caster : ModuleShadowCaster = $ShadowCaster

var shape : ParasolShape
var color : Color
var held_by_player : Player = null

func activate() -> void:
	position_handle()

func position_handle() -> void:
	var handle_size := Global.config.scale(Global.config.parasol_handle_size)
	handle.set_scale(Vector2(0.2, 1.0) * handle_size / Global.config.sprite_size)
	shadow_caster.set_position(Vector2.UP * handle_size)

func get_handle_position() -> Vector2:
	return handle.global_position

func set_shape(shp:ParasolShape) -> void:
	shape = shp
	color = Global.config.parasol_colors.pick_random()
	
	shadow_caster.set_shape(shp)
	shadow_caster.set_color(color)

func on_grabbed(p:Player) -> void:
	held_by_player = p

func on_dropped() -> void:
	held_by_player = null

func is_held() -> bool:
	return held_by_player != null
