extends Control

var keys = []
var t = float(1)
var canDisappear = true

func _ready():
	keys = get_node("ReferenceRect").get_children()
	for i in range(keys.size()):
		keys[i].modulate.a = 0.5
	while(canDisappear):
		for i in range(keys.size()):
			keys[i].modulate.a = 1
			yield(get_tree().create_timer(0.4),"timeout")
			keys[i].modulate.a = 0.5
			
			

func _input(event):
	if canDisappear:
		if event.is_action_pressed("ui_left"):
			disappear_keys()
		if event.is_action_pressed("ui_right"):
			disappear_keys()
		if event.is_action_pressed("ui_up"):
			disappear_keys()
		if event.is_action_pressed("ui_down"):
			disappear_keys()
		
func disappear_keys():
	canDisappear = false
	while(t > 0):
		for i in range(keys.size()):
			keys[i].modulate.a = t
		yield(get_tree().create_timer(0.01),"timeout")
		t-= 0.01
	queue_free()
