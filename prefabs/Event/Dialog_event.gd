extends Node2D

onready var labels = get_node("Dialog_lines").get_children()
onready var lines = []
onready var letters_duration = []
onready var dialog = get_node("/root/Main/ScreenCanvas/Dialog")

var canStart = true
func Start_Event():
	if canStart == true:
		canStart = false
		for i in range(labels.size()):
			lines.push_back(labels[i].text)
			letters_duration.push_back(labels[i].time_between_letters)
		dialog.Begin_dialog(lines,letters_duration)
