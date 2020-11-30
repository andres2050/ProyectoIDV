extends Node

export(float,0,1) var bgm_volume = 0.6
export(float,0,1) var sfx_volume = 0.6

onready var bgm_players = get_tree().get_nodes_in_group("bgm_player")
onready var sfx_players = get_tree().get_nodes_in_group("sfx_player")

func change_bgm_volume(new_volume):
	bgm_volume = new_volume
	for i in range(bgm_players.size()):
		bgm_players[i].volume_db = (sqrt(bgm_volume) * 40)-30
	
func change_sfx_volume(new_volume):
	sfx_volume = new_volume
	for i in range(sfx_players.size()):
		sfx_players[i].volume_db = (sqrt(sfx_volume) * 40)-30
