extends Button

export(String,"none", "Test_level","Start_Menu","Level_0", "Level_1", "Introduction_video" ) var scene
export(String, "Fading", "DeadFading", "DeadScreen") var animation

var sfx_path = "res://sound/sfx/ui/"
var sfx_hover = load(sfx_path + "mouse_hover.wav")
var sfx_select = load(sfx_path + "ui_select.wav")
onready var sfx = get_node("sfx_player")


export var animation_path :NodePath
var animation_duration
var animationPlayer
func _ready():
	if (animation_path):
		animationPlayer = get_node(animation_path)
		
var already_pressed = false

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
	next_scene.player_position = main_node.player_position
	next_scene.soundtrack = main_node.soundtrack
	
	get_tree().get_root().add_child(next_scene)
	main_node.queue_free()
		
func _on_Button_pressed():
	sfx.stream = sfx_select
	sfx.play()
	if (already_pressed == false) :
		already_pressed = true
		if get_name() == "Exit":
			get_tree().quit()
		else:
			if animationPlayer:
				animationPlayer.play_backwards(animation)
				
				animation_duration = animationPlayer.current_animation_length
				yield(get_tree().create_timer(animation_duration),"timeout")
			get_tree().paused = false
			change_scene_manually()



func _on_ChangeSceneButton_mouse_entered():
	sfx.stream = sfx_hover
	sfx.play()
