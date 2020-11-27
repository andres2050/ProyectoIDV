extends VideoPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	get_tree().change_scene("res://scenes/Level_1.tscn")
