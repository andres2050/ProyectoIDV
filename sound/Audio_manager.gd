extends AudioStreamPlayer

var main_node = self
var volume = 0
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	
	yield(get_tree().create_timer(1), "timeout")
	play()
	
func _process(_delta):
	if (main_node.bgm_volume > 0):
		volume = (sqrt(main_node.bgm_volume) * 40)-30
		volume_db = volume
	else:
		volume_db = -80

func _on_AudioStreamPlayer_finished():
	play()
