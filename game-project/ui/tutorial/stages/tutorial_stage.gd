extends Resource
class_name TutorialStage

@export var day := 0
@export var order := 0

@export var frame := 0
@export var desc := ""
@export var powerups_enabled := false
@export var luring_enabled := false
@export var rotate_enabled := false
@export var drop_enabled := false

func execute(t:Tutorial) -> void:
	if powerups_enabled:
		t.powerups_data.set_enabled(true)
	
	if luring_enabled:
		t.powerups_data.set_luring(true)
	
	if rotate_enabled:
		t.powerups_data.rotate_enabled = true
	
	if drop_enabled:
		t.powerups_data.drop_enabled = true
