class_name Player extends Node2D

var player_num := -1

@onready var input : ModuleInput = $Input
@onready var tourist_lure : ModuleTouristLure = $TouristLure
@onready var parasol_grabber : ModuleParasolGrabber = $ParasolGrabber
@onready var light_source : ModuleLightSource = $LightSource
@onready var mover : ModuleMover = $Mover
@onready var visuals : ModuleVisualsPlayer = $Visuals

func activate(pnum:int) -> void:
	player_num = pnum
	input.activate(pnum)
	tourist_lure.activate()
	mover.activate()
	parasol_grabber.activate()
	light_source.activate()
	visuals.activate()
