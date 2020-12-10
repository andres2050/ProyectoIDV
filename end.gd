extends CanvasLayer

onready var animation_player = get_node("AnimationPlayer")
func end():
	get_node("Control").visible = true
	animation_player.play("show_thanks")
	yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
	change_scene_manually()
	
	
func change_scene_manually():
	var next_scene = load("res://scenes/Start_Menu.tscn").instance()
	var main_node = self
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	
	get_tree().get_root().add_child(next_scene)
	main_node.queue_free()
