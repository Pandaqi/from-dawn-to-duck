extends Node

signal game_over(we_won:bool)
signal life_lost()
signal hand_to_ui(node:Node2D)
signal spawn_parasol()
signal feedback(pos:Vector2, txt:String)

func _ready() -> void:
	add_background_music()

func add_background_music() -> void:
	pass
	#var a = AudioStreamPlayer.new()
	#a.stream = preload("res://game_loop/globals/theme_song_inside_sprout.ogg")
	#a.volume_db = -16
	#a.process_mode = Node.PROCESS_MODE_ALWAYS
	#add_child(a)
	#a.play()
