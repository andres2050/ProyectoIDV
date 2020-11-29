extends AudioStreamPlayer


func _ready():
	yield(get_tree().create_timer(1), "timeout")
	play()


func _on_AudioStreamPlayer_finished():
	play()
