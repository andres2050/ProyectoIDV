extends CanvasLayer

export(String,"none", "Test_level","Start_Menu","Level_0", "Level_1") var scene

onready var animation_player = get_node("Fading/FadingPlayer") 
onready var video_player = get_node("VideoPlayer")
onready var label = get_node("Label")
var canSkip = false


func _on_VideoPlayer_finished():
	change_scene_manually()


func change_scene_manually():
	var next_scene = load("res://scenes/"+ scene + ".tscn").instance()
	get_tree().get_root().add_child(next_scene)
	var main_node = self
	while(main_node.get_parent() != get_tree().get_root()):
		print(main_node.get_parent(), get_tree().get_root())
		main_node = main_node.get_parent()
	main_node.queue_free()
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if canSkip:
			animation_player.play_backwards("Fading")
			yield(get_tree().create_timer(2),"timeout")
			_on_VideoPlayer_finished()
		else:
			canSkip = true
			label.visible = true
			yield(get_tree().create_timer(2),"timeout")
			canSkip = false
			label.visible = false
	
