class_name ModuleSunRotator extends Node2D

@export var prog_data : ProgressionData

@onready var entity : Node2D = get_parent()
@onready var indicator := $Indicator
var indicator_scale := Vector2(0.25, 0.25)

@export var arc_center := Vector2.ZERO
@export var arc_radius := 10.0
@export var auto_arc := false
@export var cur_arc_ratio := 0.0 # 0.0 is left (dawn), 1.0 is right (dusk)
@export var speed_scale := 1.0
@export var move_with_mouse := false

signal arc_started()
signal arc_ended()

func activate() -> void:
	prog_data.day_started.connect(reset)
	GSignal.hand_to_ui.emit(indicator)
	indicator.set_scale(indicator_scale * Vector2.ONE)

func reset() -> void:
	cur_arc_ratio = 0
	arc_started.emit()

func _process(dt:float) -> void:
	move_in_arc(dt)
	point_sun_at_beach()

func set_arc_data(c:Vector2, r:float) -> void:
	arc_center = c
	arc_radius = r

func get_arc_angle() -> float:
	return PI + cur_arc_ratio * PI

func move_in_arc(dt) -> void:
	if auto_arc:
		cur_arc_ratio = clamp(cur_arc_ratio + speed_scale * dt, 0.0, 1.0)
	else:
		cur_arc_ratio = prog_data.time
	
	if Global.config.sun_always_off_screen:
		var left_screen_pos := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * Vector2(0, 0.5)
		var top_screen_pos := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * Vector2(0.5, 0)
		arc_radius = 2*max(left_screen_pos.x - arc_center.x, arc_center.y - top_screen_pos.y)
	
	var pos := arc_center + Vector2.from_angle(get_arc_angle()) * arc_radius
	entity.set_position(pos)
	update_indicator()
	
	if cur_arc_ratio >= 1.0:
		arc_ended.emit()

## SCREEN POS -> WORLD
#(get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_pos
#
## WORLD POS -> SCREEN
# The same thing, just without affine_inverse

func update_indicator() -> void:
	var ind_size := 0.5 * Global.config.sprite_size * indicator_scale
	var pos := entity.get_position()
	
	# get the position of the sun as SCREEN bounds
	var pos_screen := (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()) * pos

	# detect where the sun is off-screen
	var vp_size := get_viewport_rect().size
	var off_screen_left := pos_screen.x <= 0
	var off_screen_right := pos_screen.x >= vp_size.x
	var off_screen_top := pos_screen.y <= 0
	
	# find correct angle and position to indicate this
	var angles := []
	var positions := []
	if off_screen_left:
		angles.append(PI)
		positions.append( Vector2(ind_size.x, pos_screen.y) )
	
	if off_screen_top:
		angles.append(1.5*PI)
		positions.append( Vector2(pos_screen.x, ind_size.y) )
	
	if off_screen_right:
		angles.append(2*PI)
		positions.append( Vector2(vp_size.x - ind_size.x, pos_screen.y))
	
	if angles.size() <= 0: 
		indicator.set_visible(false)
		return
	
	# mediate if off-screen both X and Y
	indicator.set_visible(true)
	var final_angle : float = 0.5 * (angles[0] + angles[1]) if angles.size() > 1 else angles[0]
	var final_pos : Vector2 = 0.5 * (positions[0] + positions[1]) if positions.size() > 1 else positions[0]
	
	indicator.set_rotation(final_angle)
	indicator.set_position(final_pos)

func point_sun_at_beach() -> void:
	var target_point := arc_center
	var angle := (target_point - global_position).angle()
	entity.set_rotation(angle)

func get_sight_line() -> Line:
	return Line.new(global_position, arc_center)

func _input(ev:InputEvent) -> void:
	if move_with_mouse and (ev is InputEventMouseMotion):
		entity.set_position(ev.position)
