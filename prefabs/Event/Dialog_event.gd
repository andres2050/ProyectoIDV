extends Node2D

onready var labels = get_node("Dialog_lines").get_children()
var lines = []
var letters_duration = []
onready var dialog
var canStart = true
var event_path = ""
var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	dialog = main_node.get_node("ScreenCanvas/Dialog")

func Start_Event():
	if canStart == true:
		canStart = false
		for i in range(labels.size()):
			lines.push_back(labels[i].text)
			letters_duration.push_back(labels[i].time_between_letters)
		dialog.Begin_dialog(lines,letters_duration, event_path)
