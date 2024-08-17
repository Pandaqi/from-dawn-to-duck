class_name Tutorial extends MainSystem

@export var powerups_data : PowerupsData
@export var prog_data : ProgressionData
@export var map : Map
@export var all_stages : Array[TutorialStage] = []
@export var tutorial_scene : PackedScene

var nodes : Array[TutorialSprite] = []

signal started()
signal done()

func activate() -> void:
	prog_data.day_started.connect(on_day_started)
	
	if OS.is_debug_build() and Global.config.debug_day_start > 0:
		for i in range(Global.config.debug_day_start):
			load_stages_for_day(i)

func on_day_started() -> void:
	if not enabled: return
	
	# remove the old ones (if needed)
	for node in nodes:
		if not is_instance_valid(node): continue
		node.queue_free()
	nodes = []
	
	# place the new ones (if there are any)
	load_stages_for_day(prog_data.day)

func load_stages_for_day(d:int) -> void:
	var stages := get_stages_for_day(d)
	if stages.size() <= 0: return
	
	var num_times_played := prog_data.get_num_plays()
	var tut_speed := 1.0 + Global.config.tutorial_speed_up_repeat_plays * (num_times_played - 1)
	var seen_this_often_enough := tut_speed > 6

	prog_data.pause()
	
	started.emit()
	
	var beach_bounds : Rect2 = map.map_data.areas.beach.get_bounds()
	var edge_margin := 2.0 * Global.config.scale(Global.config.shore_line_displacement)
	var max_available_height = beach_bounds.size.y - edge_margin
	var tutorial_raw_size := Vector2(375, 600)
	var size_per_stage := Vector2(tutorial_raw_size.x / tutorial_raw_size.y * max_available_height, max_available_height)
	
	var anchor_point := beach_bounds.get_center()
	var offset_per_stage := Vector2.RIGHT * size_per_stage
	var global_offset := -0.5 * (stages.size() - 1) * offset_per_stage
	
	var skip_pregame := OS.is_debug_build() and Global.config.skip_pregame
	
	for i in range(stages.size()):
		var stage := stages[i]
		var t : TutorialSprite = tutorial_scene.instantiate()
		nodes.append(t)
		t.set_scale(max_available_height / tutorial_raw_size.y * Vector2.ONE)
		t.set_position(anchor_point + global_offset + i * offset_per_stage)
		map.layers.add_to_layer("floor", t)
		t.set_stage(stage, tut_speed)
		stage.execute(self)
		
		t.died.connect(on_tutorial_died)
		
		if skip_pregame or seen_this_often_enough: continue
		await t.done
	
	prog_data.unpause()

func on_tutorial_died(t:TutorialSprite) -> void:
	nodes.erase(t)
	if nodes.size() > 0: return
	done.emit()

func get_stages_for_day(day:int) -> Array[TutorialStage]:
	var arr : Array[TutorialStage] = []
	for stage in all_stages:
		if stage.day != day: continue
		arr.append(stage)
	
	arr.sort_custom(func(a:TutorialStage, b:TutorialStage):
		if a.order < b.order: return true
		return false
	)
	
	return arr
