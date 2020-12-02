extends Node

var bgm_volume = 0.6
var sfx_volume = 0.6


var bgm_players = []
var sfx_players = []

func _ready():
	bgm_players = get_tree().get_nodes_in_group("bgm_player")
	sfx_players = get_tree().get_nodes_in_group("sfx_player")
	change_bgm_volume(bgm_volume)
	change_sfx_volume(sfx_volume)

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
