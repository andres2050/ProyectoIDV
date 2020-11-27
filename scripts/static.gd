extends KinematicBody2D

export var health = 15
export var damage = 0

func _process(_delta):
	if health <= 0:
		die()

func damage_health(incoming_damage, _knockbackForce):
	health=health - incoming_damage

func die():
	queue_free()
