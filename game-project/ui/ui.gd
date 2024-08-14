class_name UI extends CanvasLayer

@onready var game_ui : GameUI = $GameUI
@onready var game_over : GameOver = $GameOver
@onready var day_over : DayOver = $DayOver
@onready var overlay = $GameOverlay

func activate() -> void:
	GSignal.hand_to_ui.connect(on_ui_node_received)
	game_ui.activate()
	day_over.activate()
	game_over.activate()
	

func on_ui_node_received(n:Node2D) -> void:
	if n.get_parent(): n.get_parent().remove_child(n)
	overlay.add_child(n)
