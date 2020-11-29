extends Control

onready var animation_player = get_node("reference/AnimationPlayer")
onready var label = get_node("reference/walkitalki/bubble/Label")
onready var audio_player = get_node("AudioStreamPlayer")
var is_animation_over = true

var dialogue_lines = []
var time_between_letters = []
var actual_line = 0
var isInDialog = false
var showing_text = false


func Begin_dialog(lines, letters_duration):
	isInDialog = true
	if (is_animation_over == true):
		is_animation_over = false
		dialogue_lines = lines
		time_between_letters = letters_duration
		animation_player.play("Dialogue")
		yield(get_tree().create_timer(1.3),"timeout")
		is_animation_over = true
		Show_text()

func End_dialogue():
	if (is_animation_over == true):
		is_animation_over = false
		Hide_text()
		animation_player.play_backwards("Dialogue")
		yield(get_tree().create_timer(1.3),"timeout")
		is_animation_over = true

func Show_text():
	showing_text = true
	var actual_line_aux = actual_line
	var line_text = dialogue_lines[actual_line]
	var letter_duration = time_between_letters[actual_line]
	var text_aux = line_text
	for _i in range (line_text.length()): 
		if actual_line_aux == actual_line and showing_text:
			if(text_aux.left(1) != " "): 
				audio_player.play()
			label.text += text_aux.left(1)
			text_aux.erase(0,1)
			yield(get_tree().create_timer(letter_duration),"timeout")
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
				Show_text()
			else:
				isInDialog = false
				actual_line=0
				End_dialogue()
		


func Hide_text():
	label.text = ""
