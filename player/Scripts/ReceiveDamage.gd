extends Area2D

onready var player = get_parent()

var canDamage = true
var damageCooldown=0.2
var enemiesTouching = 0

func _process(_delta):
	if (enemiesTouching > 0 and canDamage):
		canDamage = false
		player.damage_health(50)
		yield(get_tree().create_timer(damageCooldown), "timeout")
		canDamage = true
		
	


func _on_Hurtbox_body_entered(body):
	if (body.is_in_group("enemy")):
		enemiesTouching += 1


func _on_Hurtbox_body_exited(body):
	if (body.is_in_group("enemy")):
		enemiesTouching -= 1
