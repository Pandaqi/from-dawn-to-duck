class_name Progression extends Node2D

@export var prog_data : ProgressionData
@export var tourists : Tourists
@onready var canv_mod : CanvasModulate = $CanvasModulate

func activate() -> void:
	prog_data.reset()
	
	GSignal.life_lost.connect(on_life_lost)
	prog_data.lives_changed.connect(on_lives_changed)
	GSignal.game_over.connect(on_game_over)

func on_life_lost() -> void:
	prog_data.change_lives(-1)

func on_lives_changed(new_lives:int) -> void:
	if new_lives > 0: return
	GSignal.game_over.emit(false)

func start_day() -> void:
	prog_data.start_day()

func end_day() -> void:
	prog_data.end_day()
	canv_mod.color = Global.config.night_color
	await get_tree().create_timer(1.0).timeout
	start_day()

func _process(dt:float) -> void:
	advance_time(dt)

func advance_time(dt:float) -> void:
	if not prog_data.is_day(): return
	
	var day_dur := Global.config.day_duration
	if tourists.can_end_day():
		day_dur *= Global.config.day_duration_quick_end_factor
	
	prog_data.advance_time(dt / day_dur)
	
	# change the sky to the right color
	var color_a := Global.config.dawn_color
	var color_b := Global.config.midday_color
	var blend := prog_data.time / 0.5
	if prog_data.time >= 0.5:
		color_a = Global.config.midday_color
		color_b = Global.config.dusk_color
		blend = (prog_data.time - 0.5) / 0.5
	
	var world_color := color_a.lerp(color_b, blend)
	canv_mod.color = world_color
	
	if prog_data.time < 1.0: return
	end_day()

func on_game_over(we_won : bool) -> void:
	print("GAME OVER!")
	print("We won?", we_won)
	prog_data.goto_game_over()
