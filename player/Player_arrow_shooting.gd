extends Area2D

export(int) var charSpeed =400

var movement = Vector2()

var left
var right
var up
var down
var direction

export var bulletSpeed = 1200
export var fireRate = 0.2
var bulletDirection = Vector2()

var bullet = preload("res://prefabs/bullet.tscn")

var canFire = true
var isShooting = false

func _process(delta):

	movement = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		movement += Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		movement += Vector2(1,0)
	if Input.is_action_pressed("ui_up"):
		movement += Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		movement += Vector2(0,1)
		
	#---------------------------------------------------------------------------
	#shooting
	bulletDirection = Vector2()
	if Input.is_action_pressed("shot_left"):
		bulletDirection += Vector2(-1, 0)
	if Input.is_action_pressed("shot_right"):
		bulletDirection += Vector2(1, 0)
	if Input.is_action_pressed("shot_up"):
		bulletDirection += Vector2(0, -1)
	if Input.is_action_pressed("shot_down"):
		bulletDirection += Vector2(0, 1)
		
	if bulletDirection.length() >0:
		isShooting = true
	else:
		isShooting = false
		

func _physics_process(delta):
	
	
	
	
	
	if isShooting:
		direction = get_direction(bulletDirection)
		if canFire == true:
			canFire = false
			
			var bullet_instance = bullet.instance()
			bullet_instance.position = get_global_position()
			bullet_instance.apply_impulse(Vector2(), bulletDirection.normalized() * bulletSpeed)
			get_tree().get_root().add_child(bullet_instance)
			
			
			
			yield(get_tree().create_timer(fireRate), "timeout")
			canFire = true
	else:
		direction = get_direction(movement)			
	print(direction)
	
	if movement.length() > 0: 		
		movement = movement.normalized() * charSpeed
		position += movement * delta
		$AnimatedSprite.animation = direction


func get_direction(var vector):
	match vector:
		Vector2(1,-1):
			return "rightUp"
		Vector2(0,-1):
			return "up"
		Vector2(-1,-1):
			return "leftUp"
		Vector2(-1,0):
			return "left"
		Vector2(-1,1):
			return "leftDown"
		Vector2(0,1):
			return "down"
		Vector2(1,1):
			return "rightDown"
		Vector2(1,0):
			return "right"
		_:
			return "down"

