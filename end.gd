extends CanvasLayer

onready var animation_player = get_node("AnimationPlayer")
func end():
	get_node("Control").visible = true
	animation_player.play("show_thanks")
	yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
	if get_tree().change_scene("res://scenes/Start_Menu.tscn") != OK:
		print("not ok")
