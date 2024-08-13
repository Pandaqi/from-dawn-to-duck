class_name Tourist extends Node2D

@onready var shadow_tracker : ModuleShadowTracker = $ShadowTracker
@onready var sun_burner : ModuleSunBurner = $SunBurner
@onready var target_follower : ModuleTargetFollower = $TargetFollower
@onready var state : ModuleState = $State
@onready var state_tourist : ModuleStateTourist = $StateTourist

func activate() -> void:
	state_tourist.activate()
	target_follower.activate()
	sun_burner.activate()
