class_name Player extends Node2D

var player_num := -1

@onready var input := $Input
@onready var tourist_lure := $TouristLure
@onready var parasol_grabber := $ParasolGrabber
@onready var light_source := $LightSource
@onready var mover := $Mover

func activate(pnum:int) -> void:
	player_num = pnum
	input.activate(pnum)
	tourist_lure.activate()
	mover.activate()
	parasol_grabber.activate()
