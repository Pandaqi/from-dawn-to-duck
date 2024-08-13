class_name Players extends MainSystem

var num_players := 0

@export var player_scene : PackedScene
@export var map : Map

func activate() -> void:
	GInput.create_debugging_players()
	num_players = GInput.get_player_count()
	place_players()

func place_players() -> void:
	for i in range(num_players):
		place_player(i)

func place_player(num:int) -> void:
	var p : Player = player_scene.instantiate()
	map.layers.add_to_layer("entities", p)
	var pos := map.map_data.query_position()
	p.set_position(pos)
	p.activate(num)
	
	# the player only becomes its own light source if there are no suns
	# @TODO: the alternative is to just have sun always coming straight from above or something
	p.light_source.set_enabled(not suns.enabled)
	
	# the player can only grab and move parasols if that system is active
	p.parasol_grabber.button_drops_parasol = parasols.enabled
	p.parasol_grabber.enabled = parasols.enabled
	p.tourist_lure.enabled = not parasols.enabled
