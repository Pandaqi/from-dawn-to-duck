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
signal day_changed(new_day:int)
signal time_changed(new_time:float)
signal coins_changed(new_coins:int)

func reset() -> void:
	state = ProgressionState.PREGAME
	reset_day()
	reset_time()
	reset_lives()
	reset_coins()

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

func reset_day() -> void:
	advance_day(-day)

func advance_day(dd:int) -> void:
	day += dd
	day_changed.emit(day)

func reset_time() -> void:
	advance_time(-time)

func advance_time(dt:float) -> void:
	time += dt
	time_changed.emit(time)

func reset_lives() -> void:
	var start_num := Global.config.lives_starting_num
	change_lives(-lives + start_num)

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, 9)
	lives_changed.emit(lives)

func reset_coins() -> void:
	var start_num := Global.config.coins_starting_num
	change_coins(-coins + start_num)

func change_coins(dc:int) -> void:
	coins = clamp(coins + dc, 0, 99)
	coins_changed.emit(coins)

func is_day() -> bool:
	return (state == ProgressionState.DAY)

func goto_game_over() -> void:
	state = ProgressionState.POSTGAME
