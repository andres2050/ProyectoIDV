extends Area2D

onready var player = get_parent()

var isTouchingEnemy = false
var canDamage = true
var damageCooldown=0.5

func _process(_delta):
	var bodies = get_overlapping_bodies()
	for i in range(bodies.size()):
		if(bodies[i].is_in_group("enemy")):
			isTouchingEnemy=true
			break
		else:
			isTouchingEnemy=false
	if (isTouchingEnemy and canDamage):
		canDamage = false
		player.damage_health(5)
		print(player.health)
		yield(get_tree().create_timer(damageCooldown), "timeout")
		canDamage = true
		
	
