extends AudioStreamPlayer

var main_node = self
var volume = 0

export(String, "","Start_menu","Ambiental_city", "Combat") var soundtrack_name


func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	
	self.stream = load("res://sound/bgm/"+soundtrack_name + ".ogg")
	yield(get_tree().create_timer(1), "timeout")
	play()
	
func play_soundtrack(soundtrack):
	self.stream = load("res://sound/bgm/"+ soundtrack +".ogg")
	play()

func change_soundtrack(new_soundtrack):
	while(volume_db > -30):
		volume_db -= 2
		yield(get_tree().create_timer(0.05),"timeout")
	play_soundtrack(new_soundtrack)
	volume_db = main_node.bgm_volume
