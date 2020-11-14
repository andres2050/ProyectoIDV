extends Button

export(String, "Test_level.tscn","Start_Menu.tscn") var scene
 
export var animation_path :NodePath
var animation_duration
var animation
func _ready():
	if (animation_path):
		animation = get_node(animation_path)
		
func _on_Button_pressed():
	if get_name() == "Exit":
		get_tree().quit()
	else:
		if animation:
			animation_duration = animation.current_animation_length
			
			animation.play_backwards("Fading")
			yield(get_tree().create_timer(animation_duration),"timeout")
		get_tree().paused = false
		if get_tree().change_scene("res://scenes/" + scene) != OK:
			print("An unexpected error occured when trying to switch to the Readme scene")
