extends Resource
class_name ProgressionData

enum ProgressionState
{
	PREGAME,
	DAY,
	NIGHT,
	POSTGAME
}

var is_paused := false

var state := ProgressionState.PREGAME
var day := -1
var time := -1.0 # 0.0 = start day, 1.0 = end day
var lives := -1
var coins := -1

# this is a persistent array that tracks how often you restarted
# to prevent displaying the tutorial EVERY TIME
var num_plays_per_day : Array[int] = []

signal day_ended()
signal day_started()
signal lives_changed(new_lives:int)
signal life_lost()
signal day_changed(new_day:int)
signal time_changed(new_time:float)
signal coins_changed(new_coins:int)
signal paused(p:bool)

func reset() -> void:
	state = ProgressionState.PREGAME
	reset_day()
	reset_time()
	reset_lives()
	reset_coins()

func pause() -> void:
	is_paused = true
	paused.emit(true)

func unpause() -> void:
	is_paused = false
	paused.emit(false)

func start_day() -> void:
	state = ProgressionState.DAY
	
	if num_plays_per_day.size() <= day:
		num_plays_per_day.resize(day + 1)
		num_plays_per_day[day] = 0
	num_plays_per_day[day] += 1
	
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
	if is_paused: return
	time += dt
	time_changed.emit(time)

func reset_lives() -> void:
	var start_num := Global.config.lives_starting_num
	change_lives(-lives + start_num)

func lose_life() -> void:
	change_lives(-1)
	life_lost.emit()

func change_lives(dl:int) -> void:
	var old_lives := lives
	lives = clamp(lives + dl, 0, 9)
	if old_lives != lives: lives_changed.emit(lives)

func reset_coins() -> void:
	var start_num := Global.config.coins_starting_num
	change_coins(-coins + start_num)

func change_coins(dc:int) -> void:
	var old_coins := coins
	coins = clamp(coins + dc, 0, 99)
	if old_coins != coins: coins_changed.emit(coins)

func is_day() -> bool:
	return (state == ProgressionState.DAY)

func goto_game_over() -> void:
	state = ProgressionState.POSTGAME

func is_pre_game() -> bool:
	return state == ProgressionState.PREGAME

func is_game_over() -> bool:
	return state == ProgressionState.POSTGAME

# returns 0->1 in first half of day, then 1->0 in second half
# hence, symmetric ratio around noon
func get_time_symmetric() -> float:
	return 1.0 - abs(time - 0.5) / 0.5

func get_day_duration() -> float:
	var val_raw := Global.config.day_duration + Global.config.day_duration_increase_per_day * self.day
	var val_clamped : float = min(val_raw, Global.config.day_duration_max)
	return val_clamped

func get_num_plays() -> int:
	if day >= num_plays_per_day.size(): return 0
	return num_plays_per_day[day]
