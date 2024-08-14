extends Node2D

@onready var progression := $Progression
@onready var parasols := $Parasols
@onready var tourists := $Tourists
@onready var weather : Weather = $Weather
@onready var map := $Map
@onready var players := $Players
@onready var ui : UI = $UI
@onready var powerups : Powerups = $Powerups

func _ready() -> void:
	ui.activate() # before everything else, so the other systems initialize UI to right values as they activate
	
	progression.activate()
	map.activate()
	players.activate()
	parasols.activate()
	tourists.activate()
	weather.activate()
	powerups.activate()
	
	progression.start_day()
