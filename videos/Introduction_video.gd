extends CanvasLayer

export(String,"none", "Test_level","Start_Menu","Level_0", "Level_1") var scene

onready var animation_player = get_node("Fading/FadingPlayer") 
onready var video_player = get_node("VideoPlayer")
onready var label = get_node("Label")
var canSkip = false
var isOver = false

var bgm_volume = 0.6
var sfx_volume = 0.6
var events_states = []
var dialog_states = []
var player_stats = []

func _on_VideoPlayer_finished():
	isOver = true
	change_scene_manually()


func change_scene_manually():
	var next_scene = load("res://scenes/"+ scene + ".tscn").instance()
	var main_node = self
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	next_scene.bgm_volume = main_node.bgm_volume
	next_scene.sfx_volume = main_node.sfx_volume
	next_scene.events_states = main_node.events_states
	next_scene.dialog_states = main_node.dialog_states
	next_scene.player_stats = main_node.player_stats
	get_tree().get_root().add_child(next_scene)
	main_node.queue_free()
		
func _input(event):
	if event.is_action_pressed("ui_accept") and !isOver:
		if canSkip :
			isOver = true
			animation_player.play_backwards("Fading")
			yield(get_tree().create_timer(2),"timeout")
			_on_VideoPlayer_finished()
		else:
			canSkip = true
			label.visible = true
			yield(get_tree().create_timer(2),"timeout")
			canSkip = false
			label.visible = false
	
