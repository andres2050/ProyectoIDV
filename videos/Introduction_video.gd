extends CanvasLayer

export(String,"none", "Test_level","Start_Menu","Level_0", "Level_1") var scene

onready var animation_player = get_node("Fading/FadingPlayer") 
onready var video_player = get_node("VideoPlayer")
onready var label = get_node("Label")
var canSkip = false


func _on_VideoPlayer_finished():
	if get_tree().change_scene("res://scenes/" + scene + ".tscn") != OK:
		print("An unexpected error occured when trying to switch to the scene")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if canSkip:
			animation_player.play_backwards("Fading")
			yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
			_on_VideoPlayer_finished()
		else:
			canSkip = true
			label.visible = true
			yield(get_tree().create_timer(2),"timeout")
			canSkip = false
			label.visible = false
	
