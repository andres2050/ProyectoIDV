extends Control

func _ready():
	visible = false

onready var sfx = get_node("sfx_player")
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		sfx.play()
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
