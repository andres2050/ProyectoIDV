extends Button

export(String,"none", "Test_level","Start_Menu","Level_0", "Level_1", "Introduction_video" ) var scene
export(String, "Fading", "DeadFading", "DeadScreen") var animation

export var animation_path :NodePath
var animation_duration
var animationPlayer
func _ready():
	if (animation_path):
		animationPlayer = get_node(animation_path)
		
var already_pressed = false

func change_scene_manually():
	var next_scene = load("res://scenes/"+ scene + ".tscn").instance()
	get_tree().get_root().add_child(next_scene)
	var main_node = self
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	main_node.queue_free()
		
func _on_Button_pressed():
	if (already_pressed == false) :
		already_pressed = true
		if get_name() == "Exit":
			get_tree().quit()
		else:
			if animationPlayer:
				animationPlayer.play_backwards(animation)
				
				animation_duration = animationPlayer.current_animation_length
				yield(get_tree().create_timer(animation_duration),"timeout")
			get_tree().paused = false
			change_scene_manually()
#			if get_tree().change_scene("res://scenes/" + scene + ".tscn") != OK:
#				print("An unexpected error occured when trying to switch to the Readme scene")
