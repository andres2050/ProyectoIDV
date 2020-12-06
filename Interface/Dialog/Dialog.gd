extends CanvasLayer

onready var animation_player = get_node("reference/AnimationPlayer")
onready var spacebar_animation = get_node("reference/Space_bar/AnimationPlayer")
onready var spacebar = get_node("reference/Space_bar")
onready var label = get_node("reference/walkitalki/bubble/Label")
onready var audio_player = get_node("AudioStreamPlayer")
var is_animation_over = true

var dialogue_lines = []
var time_between_letters = []
var path_to_event
var actual_line = 0
var isInDialog = false
var showing_text = false
var answered_call = false 

var player
var dialog_bus = []
func _ready():
	spacebar_animation.stop(true)
	yield(get_tree().create_timer(0,01),"timeout")
	player = get_tree().get_nodes_in_group("player")[0]

func Begin_dialog(lines, letters_duration, event_path):
	if !isInDialog:
		isInDialog = true
		player.stop_moving()
		is_animation_over = false
		dialogue_lines = lines
		time_between_letters = letters_duration
		path_to_event = event_path
		animation_player.play("show_walkitalki")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		
		answered_call = false 
		animation_player.play("ring_walkitalki")
		spacebar_animation.play("show_spacebar")
		spacebar_animation.queue("press_spacebar")
		while(!answered_call):
			yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
			animation_player.play("ring_walkitalki")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		
		animation_player.play("show_bubble")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		is_animation_over = true
		if lines.size() > 0:
			Show_text()
	else:
		dialog_bus.push_back([lines, letters_duration,event_path])

func End_dialogue():
	if (is_animation_over == true):
		if path_to_event == "":
			player.canMove = true
		is_animation_over = false
		Hide_text()
		spacebar_animation.play_backwards("show_spacebar")
		animation_player.play_backwards("show_bubble")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		animation_player.play_backwards("show_walkitalki")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		spacebar_animation.stop(true)
		
		is_animation_over = true
		if path_to_event != "":
			get_node(path_to_event).dialog_ended()
		isInDialog = false
		if dialog_bus.size() > 0:
			var next_dialog = dialog_bus.pop_front()
			Begin_dialog(next_dialog[0],next_dialog[1],next_dialog[2])
		

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
		if is_animation_over:
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
					actual_line=0
					End_dialogue()
		else:
			answered_call = true

func Hide_text():
	label.text = ""
