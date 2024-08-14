class_name Menu extends Control

@onready var play_btn := $CenterContainer/VBoxContainer/Play

func _ready():
	get_tree().paused = false
	play_btn.grab_focus()

func _on_play_pressed() -> void:
	# @TODO: this is just a placeholder for the singleplayer; if the game becomes multiplayer later, this would just be replaced by an input select screen
	if GInput.get_player_count() <= 0:
		GInput.add_new_player(GInput.InputDevice.KEYBOARD)
	get_tree().change_scene_to_packed(preload("res://game_loop/main/main.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()
