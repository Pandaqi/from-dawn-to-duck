class_name Tourist extends Node2D

@onready var shadow_tracker : ModuleShadowTracker = $ShadowTracker
@onready var sun_burner : ModuleSunBurner = $SunBurner
@onready var target_follower : ModuleTargetFollower = $TargetFollower
@onready var state : ModuleState = $State
@onready var state_tourist : ModuleStateTourist = $StateTourist
@onready var body : ModuleBody = $Body
@onready var visuals : ModuleVisualsTourist = $Visuals

func activate() -> void:
	visuals.activate()
	state_tourist.activate()
	target_follower.activate()
	sun_burner.activate()
	shadow_tracker.activate()
	body.activate() # should come later, because its size changes are a signal that should be listened to by some others 
	
