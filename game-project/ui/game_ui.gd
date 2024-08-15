class_name GameUI extends Node2D

@export var prog_data : ProgressionData
@export var weather_data : WeatherData

@onready var time_cont := $Time
@onready var time_label := $Time/Label

@onready var day_cont := $Day
@onready var day_label := $Day/Label

@onready var lives_cont := $Lives
@onready var lives_label := $Lives/Label

@onready var coins_cont := $Coins
@onready var coins_label := $Coins/Label

@onready var heat_cont := $Heat
@onready var heat_label := $Heat/Label
@onready var heat_thermometer := $Heat/Cont/TextureProgressBar
@onready var heat_anim_player := $Heat/AnimationPlayer

var offset_per_node : float
var margin_per_node := 0.075
var margin_to_edge := 0.1

func activate() -> void:
	prog_data.time_changed.connect(on_time_changed)
	prog_data.day_changed.connect(on_day_changed)
	prog_data.lives_changed.connect(on_lives_changed)
	prog_data.coins_changed.connect(on_coins_changed)
	weather_data.heat_changed.connect(on_heat_changed)
	
	offset_per_node = (1.0 + margin_per_node) * Global.config.sprite_size
	
	get_viewport().size_changed.connect(on_resize)
	on_resize()

# @TODO: pull out reused values (for x/y pos and such), make cleaner
func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	var edge_margin := Global.config.sprite_size * margin_to_edge * Vector2.ONE
	
	time_cont.set_position( Vector2(edge_margin.x / scale.x, 0.5 * offset_per_node + edge_margin.y / scale.y) )
	day_cont.set_position( Vector2(edge_margin.x / scale.x, 1.5 * offset_per_node + edge_margin.y / scale.y) )
	heat_cont.set_position( Vector2(edge_margin.x / scale.x, 2.5 * offset_per_node + edge_margin.y / scale.y) )
	
	lives_cont.set_position( Vector2((vp_size.x - edge_margin.x) / scale.x, 0.5 * offset_per_node + edge_margin.y / scale.y) )
	coins_cont.set_position( Vector2((vp_size.x - edge_margin.x) / scale.x, 1.5 * offset_per_node + edge_margin.y / scale.y) )

func on_time_changed(t:float) -> void:
	time_label.set_text(to_pretty_time_string(t))

func on_day_changed(d:int) -> void:
	day_label.set_text("Day " + str(d + 1))
	animate_pop_up(day_cont)

func on_lives_changed(l:int) -> void:
	lives_label.set_text(str(l))
	animate_pop_up(lives_cont)

func on_coins_changed(c:int) -> void:
	coins_label.set_text(str(c))
	animate_pop_up(coins_cont)

func on_heat_changed(h:float) -> void:
	var heat_nice := int( round(h) )
	heat_label.set_text(str(heat_nice) + " °C")
	
	var heat_ratio := weather_data.get_heat_ratio()
	heat_thermometer.set_value(heat_ratio * 100.0)
	
	var tint := Global.config.heat_color_low.lerp(Global.config.heat_color_high, heat_ratio)
	heat_thermometer.tint_progress = tint
	
	if heat_nice > Global.config.heat_extreme:
		heat_anim_player.play("heat_blink")
	else:
		heat_anim_player.stop()

func to_pretty_time_string(ratio:float) -> String:
	var time_bounds := Global.config.day_time_bounds_hours
	var total_minutes : int = int( round(time_bounds.interpolate(ratio) * 60) )
	
	var hours_only = floor(total_minutes / 60.0)
	if hours_only < 10:
		hours_only = "0" + str(hours_only)
	
	var minutes_only = total_minutes % 60
	if minutes_only < 10:
		minutes_only = "0" + str(minutes_only)
	
	return str(hours_only) + ":" + str(minutes_only)

func animate_pop_up(node:Node2D) -> void:
	var tw := get_tree().create_tween()
	var rand_dur := randf_range(0.06, 0.12)
	var rand_scale := randf_range(1.125, 1.35) 
	tw.tween_property(node, "scale", Vector2.ONE * rand_scale, 0.5*rand_dur)
	tw.parallel().tween_property(node, "modulate", Color(2,1.5,1.5), 0.5*rand_dur)
	tw.tween_property(node, "scale", Vector2.ONE, rand_dur)
	tw.parallel().tween_property(node, "modulate", Color(1,1,1), rand_dur)
