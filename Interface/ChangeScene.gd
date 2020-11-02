extends Button

export(String, "main.tscn","Start_Menu.tscn") var scene
 
export var animation_path :NodePath
onready var animation = get_node(animation_path)
var animation_duration
func _on_Button_pressed():
	animation_duration = animation.current_animation_length
	
	if get_name() == "Exit":
		get_tree().quit()
	else:
		if animation != null:
			animation.play_backwards("Fading")
			yield(get_tree().create_timer(animation_duration),"timeout")
		get_tree().paused = false
		if get_tree().change_scene("res://scenes/"+scene) != OK:
			print("An unexpected error occured when trying to switch to the Readme scene")
