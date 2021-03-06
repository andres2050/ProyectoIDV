extends Area2D

var bullet

var bulletDamage
var canPierce
var knockbackForce

var canHit = true
var enemy

func _ready():
	 bullet = get_parent()
	 bulletDamage = bullet.bulletDamage
	 canPierce = bullet.canPierce
	 knockbackForce = bullet.knockbackForce


func _on_Hitbox_area_entered(area):
	enemy = area.get_parent()
	if canHit and enemy.is_in_group("enemy"):
		canHit = false
		enemy.damage_health(bulletDamage, knockbackForce)
		if !canPierce:
			get_parent().queue_free()
		else:
			canHit = true
	


func _on_Hitbox_body_entered(body):
	if !body.is_in_group("player") and !body.is_in_group("enemy") and !body.is_in_group("scenario_collisions"):
		get_parent().queue_free()
