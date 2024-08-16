extends Node2D

@export var sun_burner : ModuleSunBurner
@export var shadow_tracker : ModuleShadowTracker
@onready var anim_player_flash : AnimationPlayer = $AnimationPlayerFlash
@onready var anim_player_fire : AnimationPlayer = $AnimationPlayerFire
@onready var visuals : ModuleVisualsTourist = get_parent()

func activate() -> void:
	sun_burner.changed.connect(on_burn_changed)

func on_burn_changed(ratio:float) -> void:
	set_scale(visuals.get_sprite_scale())
	
	if ratio <= Global.config.burn_near_anim_ratio or shadow_tracker.is_in_shadow(): 
		anim_player_flash.stop()
		anim_player_fire.stop()
		set_visible(false)
		return
	
	anim_player_flash.play("near_burn_flash")
	anim_player_fire.play("flicker")
	set_visible(true)
