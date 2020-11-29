extends VideoPlayer


export(String, "Test_level","Start_Menu","Level_0", "Level_1") var scene

func _ready():
	play()

func _on_VideoPlayer_finished():
	if get_tree().change_scene("res://scenes/" + scene + ".tscn") != OK:
		print("An unexpected error occured when trying to switch to the Readme scene")
