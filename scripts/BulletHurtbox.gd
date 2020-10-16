extends Area2D

onready var bulletDamage = get_parent().bulletDamage

onready var canPierce = get_parent().canPierce
var canHit = true

func _on_Hitbox_area_entered(area):
	if canHit:
		canHit = false
		area.get_parent().damage_health(bulletDamage)
		if !canPierce:
			get_parent().queue_free()
		canHit = true
		canPierce = false
	


func _on_Hitbox_body_entered(body):
	if !body.is_in_group("player"):
		get_parent().queue_free()
