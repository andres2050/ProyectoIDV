extends Node2D

var events
var dialog_events
var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	yield(get_tree().create_timer(0.01),"timeout")
	events = main_node.get_node("Events").get_children()
	dialog_events = main_node.get_node("Dialog_Events").get_children()


func _on_Show_keys_tree_exiting():
	search_dialog("First_call").Start_Event()


func search_event(event_name):
	for i in range(events.size()):
		if events[i].get_name == event_name:
			return events[i]

func search_dialog(dialog_name):
	for i in range(dialog_events.size()):
		if dialog_events[i].get_name() == dialog_name:
			return dialog_events[i]
