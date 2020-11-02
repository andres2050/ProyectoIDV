extends Button

export(String, "main.tscn","Start_Menu.tscn") var scene
 

func _on_Button_pressed():
	if get_name() == "Exit":
		get_tree().quit()
	else:
		get_tree().paused = false
		if get_tree().change_scene("res://scenes/"+scene) != OK:
			print("An unexpected error occured when trying to switch to the Readme scene")
