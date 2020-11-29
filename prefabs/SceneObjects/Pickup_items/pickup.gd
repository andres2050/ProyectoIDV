extends Area2D




func _on_pickupDetector_body_entered(body):
	if(body.is_in_group("player")):
		body.pickup_item()
		pickup()
		

func pickup():
	get_parent().queue_free()
