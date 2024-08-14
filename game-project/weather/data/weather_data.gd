extends Resource
class_name WeatherData

var time_scale := 1.0

signal time_scale_changed(ts:float)

func reset() -> void:
	reset_for_day()

func reset_for_day() -> void:
	time_scale = 1.0

func change_time_scale(ds:float) -> void:
	time_scale = clamp(time_scale * ds, 0.25, 4.0)
	time_scale_changed.emit(time_scale)
