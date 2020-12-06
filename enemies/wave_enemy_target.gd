extends Node2D



func _on_target_body_entered(body):
	if body.is_in_group("wave_enemy"):
		body.queue_free()
