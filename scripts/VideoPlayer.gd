extends VideoPlayer

func _ready():
	play()

func _on_VideoPlayer_finished():
	if get_tree().change_scene("res://scenes/Level_1.tscn") != OK:
		print("An unexpected error occured when trying to switch to the Readme scene")
