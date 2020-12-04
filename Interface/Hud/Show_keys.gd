extends Control

var keys = []
var t = float(1)
var canDisappear = false
var animation_player
func _ready():
	animation_player = get_node("ReferenceRect/AnimationPlayer")
	keys = get_node("ReferenceRect").get_children()
	canDisappear = true
	while(canDisappear):
		for i in range(4):
			keys[i].modulate.a = 1
			yield(get_tree().create_timer(0.3),"timeout")
			keys[i].modulate.a = 0.5
			if !canDisappear:
				break
	queue_free()
			
var canGetInput = true
func _input(event):
	if canDisappear and canGetInput:
		if event.is_action_pressed("ui_left"):
			disappear_keys()
		if event.is_action_pressed("ui_right"):
			disappear_keys()
		if event.is_action_pressed("ui_up"):
			disappear_keys()
		if event.is_action_pressed("ui_down"):
			disappear_keys()
		
func disappear_keys():
	canGetInput = false
	animation_player.play_backwards("show_spacebar")
	yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
	canDisappear = !canDisappear
