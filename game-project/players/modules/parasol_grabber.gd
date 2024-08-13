class_name ModuleParasolGrabber extends Node2D

var parasol : Parasol = null
var button_drops_parasol := true
var button_grabs_parasol := false
var enabled := true
var last_parasol_dropped : Parasol = null

@export var input : ModuleInput

signal changed(p:Parasol)
signal dropped()

func activate() -> void:
	input.button_pressed.connect(on_button_pressed)

func _process(_dt:float) -> void:
	keep_with_player()
	if not button_grabs_parasol:
		check_for_parasols_in_range()

func keep_with_player() -> void:
	if not has_parasol(): return
	parasol.set_position(global_position)

func check_for_parasols_in_range() -> void:
	if has_parasol(): return
	if not enabled: return
	
	var paras := get_tree().get_nodes_in_group("Parasols")
	var grab_dist := Global.config.scale(Global.config.grab_dist)
	
	var closest_para : Parasol = null
	var closest_dist := INF
	
	for para in paras:
		var dist : float = para.get_handle_position().distance_to(global_position)
		if dist > grab_dist: continue
		if dist > closest_dist: continue
		closest_dist = dist
		closest_para = para
	
	if not closest_para or closest_para != last_parasol_dropped:
		last_parasol_dropped = null 
	
	if not closest_para: return
	grab(closest_para)

func has_parasol() -> bool:
	return parasol != null

func can_grab(p:Parasol) -> bool:
	return p != last_parasol_dropped

func grab(p:Parasol) -> void:
	if has_parasol(): return
	if not can_grab(p): return
	parasol = p
	changed.emit(parasol)

func drop() -> void:
	if not has_parasol(): return
	parasol.set_position(global_position)
	last_parasol_dropped = parasol
	parasol = null
	dropped.emit()

func on_button_pressed() -> void:
	if button_drops_parasol: 
		drop()
	
	if button_grabs_parasol: 
		check_for_parasols_in_range()
