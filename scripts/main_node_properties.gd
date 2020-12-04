extends Node

var bgm_volume = 0.6
var sfx_volume = 0.6

var events_states = []
var dialog_states = []

var bgm_players = []
var sfx_players = []

var scripting
func _ready():
	bgm_players = get_tree().get_nodes_in_group("bgm_player")
	sfx_players = get_tree().get_nodes_in_group("sfx_player")
	change_bgm_volume(bgm_volume)
	change_sfx_volume(sfx_volume)
	yield(get_tree().create_timer(0.01),"timeout")
	var scenario = get_tree().get_nodes_in_group("Scenario")
	if scenario.size() > 0:
		scenario[0].visible = true

func refresh_events():
	get_node("Scripting").refresh_events()

func refresh_states():
	get_node("Scripting").refresh_states()

func change_bgm_volume(new_volume):
	bgm_volume = new_volume
	for i in range(bgm_players.size()):
		if (bgm_players[i] != null):
			bgm_players[i].volume_db = (sqrt(bgm_volume) * 40)-30
			
	
func change_sfx_volume(new_volume):
	sfx_volume = new_volume
	for i in range(sfx_players.size()):
		if (sfx_players[i] != null):
			sfx_players[i].volume_db = (sqrt(sfx_volume) * 40)-30
