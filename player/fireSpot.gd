extends Node2D

export var bulletSpeed = 1000
export var fireRate = 0.2
var chara

var bullet = preload("res://prefabs/bullet.tscn")

var canFire = true



func _physics_process(delta):
	chara = get_owner()
	
	var bulletDirection = Vector2()
	
	if Input.is_action_pressed("shot_left"):
		bulletDirection += Vector2(-1, 0)
	if Input.is_action_pressed("shot_right"):
		bulletDirection += Vector2(1, 0)
	if Input.is_action_pressed("shot_up"):
		bulletDirection += Vector2(0, -1)
	if Input.is_action_pressed("shot_down"):
		bulletDirection += Vector2(0, 1)
		
	
	if bulletDirection.length() > 0 and canFire == true:
		canFire = false
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_global_position()
		bullet_instance.apply_impulse(Vector2(), bulletDirection * bulletSpeed)
		get_tree().get_root().add_child(bullet_instance)
		yield(get_tree().create_timer(fireRate), "timeout")
		canFire = true
		
