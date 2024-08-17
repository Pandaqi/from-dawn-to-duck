class_name Progression extends Node2D

@export var prog_data : ProgressionData
@export var tourists : Tourists
@export var weather_data : WeatherData
@export var day_over : DayOver
@onready var canv_mod : CanvasModulate = $CanvasModulate

func activate() -> void:
	prog_data.reset()
	
	if OS.is_debug_build() and Global.config.debug_day_start > 0:
		prog_data.advance_day(Global.config.debug_day_start)
	
	GSignal.life_lost.connect(on_life_lost)
	prog_data.lives_changed.connect(on_lives_changed)
	GSignal.game_over.connect(on_game_over)

func on_life_lost() -> void:
	prog_data.lose_life()

func on_lives_changed(new_lives:int) -> void:
	if new_lives > 0: return
	GSignal.game_over.emit(false)

func start_day() -> void:
	prog_data.start_day()

func end_day() -> void:
	prog_data.end_day()
	day_over.appear()
	await day_over.dismissed
	start_day()

func _process(dt:float) -> void:
	advance_time(dt)
	update_canvas_modulate(dt)

func update_canvas_modulate(dt:float) -> void:
	# change the sky to the right color
	var color_a := Global.config.dawn_color
	var color_b := Global.config.midday_color
	var blend := prog_data.time / 0.5
	if prog_data.time >= 0.5:
		color_a = Global.config.midday_color
		color_b = Global.config.dusk_color
		blend = (prog_data.time - 0.5) / 0.5
	
	var world_color := color_a.lerp(color_b, blend)
	
	# darken if cloudy
	if weather_data.cloudy:
		world_color = world_color.darkened(Global.config.weather_cloudy_darken_factor)
	
	if prog_data.day_is_over():
		world_color = Global.config.night_color
	
	var cur_color := canv_mod.color
	var color_smoothed := cur_color.lerp(world_color, 4.0*dt)
	
	canv_mod.color = color_smoothed

func advance_time(dt:float) -> void:
	if not prog_data.is_day(): return
	
	var day_dur := prog_data.get_day_duration()
	if tourists.can_end_day():
		day_dur *= Global.config.day_duration_quick_end_factor
	
	var factor := dt / day_dur
	factor *= weather_data.time_scale
	
	prog_data.advance_time(factor)
	
	if prog_data.time < 1.0: return
	end_day()

func on_game_over(we_won : bool) -> void:
	print("GAME OVER!")
	print("We won?", we_won)
	prog_data.goto_game_over()
