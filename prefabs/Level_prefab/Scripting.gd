extends Node2D

var events
var events_states = []
var dialog_events
var dialog_states = []
var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	yield(get_tree().create_timer(0.01),"timeout")
	events = main_node.get_node("Events").get_children()
	dialog_events = main_node.get_node("Dialog_Events").get_children()
	events_states = get_parent().events_states
	dialog_states = get_parent().dialog_states
	refresh_events()
	refresh_states()
			
				
func refresh_states():
	events_states = []
	dialog_states = []
	if events.size() > 0:
		for i in range(events.size()):
			 events_states.push_back(events[i].canStart)
	if dialog_events.size() > 0:
		for i in range(dialog_events.size()):
			 dialog_states.push_back(dialog_events[i].canStart)
	main_node.events_states = events_states
	main_node.dialog_states = dialog_states
			
func refresh_events():
	if events_states.size() > 0:
		for i in range(events.size()):
			events[i].canStart = events_states[i]
	if dialog_states.size() > 0:
		for i in range(dialog_events.size()):
			dialog_events[i].canStart = dialog_states[i]
	
			
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
