extends Node2D

@onready var progression := $Progression
@onready var parasols := $Parasols
@onready var tourists := $Tourists
@onready var suns := $Suns
@onready var map := $Map
@onready var players := $Players

func _ready() -> void:
	progression.activate()
	map.activate()
	players.activate()
	parasols.activate()
	tourists.activate()
	suns.activate()
	
	progression.start_day()
