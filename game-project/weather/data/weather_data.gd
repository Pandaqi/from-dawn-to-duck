extends Resource
class_name WeatherData

var time_scale := 1.0
var heat_bounds : Bounds
var heat := 0.0
var heat_scale := 1.0
var spawner : SpawnerClouds
var cloudy := false
var weather_variation := 0.0

signal time_scale_changed(ts:float)
signal heat_scale_changed(hs:float)
signal heat_changed(h:float)
signal cloudy_changed(c:bool)

func reset() -> void:
	cloudy = false
	reset_for_day()

func set_cloudy(c:bool) -> void:
	if c == cloudy: return
	cloudy = c
	cloudy_changed.emit(cloudy)

func reset_for_day() -> void:
	time_scale = 1.0
	heat_scale = 1.0
	heat = 0.0
	weather_variation = 0.0

func change_time_scale(ds:float) -> void:
	time_scale = clamp(time_scale * ds, 0.25, 4.0)
	time_scale_changed.emit(time_scale)

func change_heat_scale(dhs:float) -> void:
	heat_scale = clamp(heat_scale * dhs, 0.25, 4.0)
	heat_scale_changed.emit(heat_scale)

func update_heat(tm_sym:float) -> void:
	heat = heat_bounds.interpolate(tm_sym) * heat_scale
	heat_changed.emit(heat)

func get_heat_ratio() -> float:
	var min_heat := Global.config.heat_bounds_min.start
	var max_heat := Global.config.heat_bounds_max.end
	var frac : float = clamp( (heat - min_heat) / (max_heat - min_heat), 0.0, 1.0)
	return frac
