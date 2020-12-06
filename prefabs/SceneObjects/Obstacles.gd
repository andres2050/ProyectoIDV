extends StaticBody2D

var smooth_fade = 0.001
var entered = false
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		entered = true
		while(modulate.a > 0.4 and entered):
			yield(get_tree().create_timer(smooth_fade),"timeout")
			modulate.a -= 0.06
		



func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		entered = false
		while(modulate.a < 1 and !entered):
			yield(get_tree().create_timer(smooth_fade),"timeout")
			modulate.a += 0.01
