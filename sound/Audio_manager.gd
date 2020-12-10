extends AudioStreamPlayer

var main_node = self
var volume = 0
var resume_moment = 0

export(String, "","Start_menu","Ambiental_city", "Combat", "In_Station", "Final_Boss") var soundtrack_name


func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	self.stream = load("res://sound/bgm/"+soundtrack_name + ".ogg")
	yield(get_tree().create_timer(1), "timeout")
	play()
	
func play_soundtrack(soundtrack,moment):
	self.stream = load("res://sound/bgm/"+ soundtrack +".ogg")
	play(moment)
	
func change_soundtrack(new_soundtrack):
		while(volume_db > -80):
			volume_db -= 4
			yield(get_tree().create_timer(0.05),"timeout")
			
		if new_soundtrack != soundtrack_name:
			resume_moment = get_playback_position()
			play_soundtrack(new_soundtrack,0.1)
			volume_db = -80
			while(volume_db < (main_node.bgm_volume*80)-80 ):
				volume_db += 4
				yield(get_tree().create_timer(0.05),"timeout")
		else:
			play_soundtrack(new_soundtrack, resume_moment)
			volume_db = -80
			while(volume_db < (main_node.bgm_volume*80)-80):
				volume_db += 4
				yield(get_tree().create_timer(0.05),"timeout")
