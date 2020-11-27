extends Control

onready var animation_player = get_node("reference/AnimationPlayer")
var is_animation_over = true

var dialogue_lines = []
var text_speed = 0.02
var actual_line = 0
var isInDialog = false
var showing_text = false

onready var label = get_node("reference/walkitalki/bubble/Label")

func Begin_dialog(lines):
	isInDialog = true
	if (is_animation_over == true):
		is_animation_over = false
		dialogue_lines = lines
		animation_player.play("Dialogue")
		yield(get_tree().create_timer(1.3),"timeout")
		is_animation_over = true
		Show_text(text_speed)

func End_dialogue():
	if (is_animation_over == true):
		is_animation_over = false
		Hide_text()
		animation_player.play_backwards("Dialogue")
		yield(get_tree().create_timer(1.3),"timeout")
		is_animation_over = true

func Show_text(textSpeed):
	showing_text = true
	var actual_line_aux = actual_line
	var line_text = dialogue_lines[actual_line]
	var text_aux = line_text
	for _i in range (line_text.length()): 
		if actual_line_aux == actual_line and showing_text:
			yield(get_tree().create_timer(textSpeed),"timeout")
			label.text += text_aux.left(1)
			text_aux.erase(0,1)
	showing_text = false
	
func Instant_show_text():
	label.text = dialogue_lines[actual_line]
	

func _input(event):
	if isInDialog and event.is_action_pressed("ui_accept"):
		if showing_text == true :
			showing_text = false
			yield(get_tree().create_timer(0.1),"timeout")
			Instant_show_text()
		else:
			actual_line += 1
			if actual_line < dialogue_lines.size():
				Hide_text()
				yield(get_tree().create_timer(0.1),"timeout")
				Show_text(text_speed)
			else:
				isInDialog = false
				actual_line=0
				End_dialogue()
		


func Hide_text():
	label.text = ""
