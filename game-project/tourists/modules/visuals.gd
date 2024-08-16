class_name ModuleVisualsTourist extends Node2D

@export var body : ModuleBody
@export var state : ModuleState
@onready var sprite_cont : Node2D = $SpriteCont
@onready var sprite : Sprite2D = $SpriteCont/Sprite2D
@export var target_follower : ModuleTargetFollower
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var in_sun_wigglies := $InSunWigglies
@onready var burn_effects := $BurnEffects
@onready var entity : Tourist = get_parent()

func activate() -> void:
	state.died.connect(on_died)
	body.size_changed.connect(on_size_changed)
	target_follower.moved.connect(on_moved)
	target_follower.stopped.connect(on_stopped)
	in_sun_wigglies.activate()
	burn_effects.activate()

func on_died(_node, is_bad:bool) -> void:
	if not is_bad:
		entity.queue_free()
		return
	
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(self, "scale", 4.0 * Vector2.ONE, 0.9)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.1)
	tw.tween_callback(func(): 
		entity.queue_free()
	)
	
	GSignal.life_lost.emit()


func on_size_changed(s:float) -> void:
	sprite_cont.set_scale(Vector2.ONE * s / Global.config.sprite_size)

func on_moved(vec:Vector2, speed:float) -> void:
	sprite.flip_h = (vec.x < 0)
	anim_player.speed_scale = speed / (Global.config.scale(Global.config.walk_anim_base_speed)) 
	anim_player.play("walk")

func on_stopped() -> void:
	anim_player.stop() # must come before setting the frame manually of course
	sprite.set_frame(3)

func get_sprite_scale() -> Vector2:
	return sprite_cont.scale

func get_center_pos() -> Vector2:
	return sprite.get_position() * get_sprite_scale()

func get_pos_around() -> Vector2:
	var radius := 0.585 * sprite_cont.scale.x * Global.config.sprite_size
	return get_center_pos() + Vector2.from_angle(randf() * 2 * PI) * radius
