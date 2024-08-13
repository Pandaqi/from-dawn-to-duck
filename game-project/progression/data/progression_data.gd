extends Resource
class_name ProgressionData

enum ProgressionState
{
	PREGAME,
	DAY,
	NIGHT,
	POSTGAME
}


var state := ProgressionState.PREGAME
var day := 0
var time := 0.0 # 0.0 = start day, 1.0 = end day
var lives := 1
var coins := 0

signal day_ended()
signal day_started()
signal lives_changed(new_lives:int)

func reset() -> void:
	state = ProgressionState.PREGAME
	day = 0
	time = 0.0
	lives = 1
	coins = 0

func start_day() -> void:
	state = ProgressionState.DAY
	print("DAY STARTED", day)
	day_started.emit()

func end_day() -> void:
	state = ProgressionState.NIGHT
	print("DAY ENDED ", day)
	day_ended.emit()
	
	reset_time()
	advance_day(1)

func advance_day(dd:int) -> void:
	day += dd

func reset_time() -> void:
	time = 0.0

func advance_time(dt:float) -> void:
	time += dt

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, 9)
	lives_changed.emit(lives)

func is_day() -> bool:
	return (state == ProgressionState.DAY)

func goto_game_over() -> void:
	state = ProgressionState.POSTGAME
