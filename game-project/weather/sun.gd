class_name Sun extends Node2D

@onready var light_source : ModuleLightSource = $LightSource
@onready var sun_rotator : ModuleSunRotator = $SunRotator

func activate() -> void:
	light_source.activate()
	sun_rotator.activate()
