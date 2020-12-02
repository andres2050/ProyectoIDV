extends Area2D

export(String, "", "heal", "buff","weapon")var pickupType


func _on_pickupDetector_body_entered(body):
	if(body.is_in_group("player")):
		body.pickup_item(pickupType)
		pickup()
		

func pickup():
	get_parent().queue_free()
