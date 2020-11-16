extends Button

export(String, "Test_level","Start_Menu","Level_0", "Level_1" ) var scene
export(String, "Fading", "DeadFading", "DeadScreen") var animation

export var animation_path :NodePath
var animation_duration
var animationPlayer
func _ready():
	if (animation_path):
		animationPlayer = get_node(animation_path)
		
func _on_Button_pressed():
	if get_name() == "Exit":
		get_tree().quit()
	else:
		if animationPlayer:
			animationPlayer.play_backwards(animation)
			
			animation_duration = animationPlayer.current_animation_length
			yield(get_tree().create_timer(animation_duration),"timeout")
		get_tree().paused = false
		if get_tree().change_scene("res://scenes/" + scene + ".tscn") != OK:
			print("An unexpected error occured when trying to switch to the Readme scene")
