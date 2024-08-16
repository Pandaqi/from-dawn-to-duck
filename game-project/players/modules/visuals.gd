class_name ModuleVisualsPlayer extends Node2D

@export var mover : ModuleMover
@onready var sprite_cont := $SpriteCont
@onready var sprite : Sprite2D = $SpriteCont/Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func activate() -> void:
	mover.moved.connect(on_moved)
	mover.stopped.connect(on_stopped)
	sprite_cont.set_scale(Global.config.player_sprite_scale * Vector2.ONE)

func on_moved(vec:Vector2, speed:float) -> void:
	sprite.flip_h = (vec.x < 0)
	anim_player.speed_scale = min(speed / (Global.config.scale(Global.config.walk_anim_base_speed)), Global.config.walk_anim_max_speed_scale) 
	anim_player.play("walk")

func on_stopped() -> void:
	anim_player.stop() # must come before setting the frame manually of course
	sprite.set_frame(7)
