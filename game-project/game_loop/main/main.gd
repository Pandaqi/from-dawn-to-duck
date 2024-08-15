extends Node2D

@onready var progression : Progression = $Progression
@onready var parasols : Parasols = $Parasols
@onready var tourists : Tourists = $Tourists
@onready var weather : Weather = $Weather
@onready var map : Map = $Map
@onready var players : Players = $Players
@onready var ui : UI = $UI
@onready var powerups : Powerups = $Powerups
@onready var tutorial : Tutorial = $Tutorial

func _ready() -> void:
	ui.activate() # before everything else, so the other systems initialize UI to right values as they activate
	
	progression.activate()
	map.activate()
	players.activate()
	parasols.activate()
	tourists.activate()
	weather.activate()
	powerups.activate()
	tutorial.activate()
	
	progression.start_day()
