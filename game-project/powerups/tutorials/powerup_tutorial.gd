class_name PowerupTutorial extends Node2D

var type : PowerupType

@onready var label : Label = $Label
@onready var icon : Sprite2D = $Icon

func set_type(tp:PowerupType) -> void:
	type = tp
	
	icon.set_frame(tp.frame)
	label.set_text(tp.desc)
