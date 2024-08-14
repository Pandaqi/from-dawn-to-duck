class_name Menu extends Control

@onready var play_btn := $CenterContainer/VBoxContainer/Play

func _ready():
	get_tree().paused = false
	play_btn.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://game_loop/main/main.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()
