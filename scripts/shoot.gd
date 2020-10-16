extends Sprite


var bullet = preload("res://prefabs/bullet.tscn")
var bullet_instance
export var default_bulletSpeed = 1.0
export var default_fireCooldown = 1.0
export var default_bulletDamage = 1.0

export var shootMode = 1

const canPierce = true
var canFire = true
const angleOpening = PI/24


onready var player = get_parent()

export var yOffSet= 10
export var radius = 30

var x = 0
var y = 0

func _process(_delta):
	if(Input.is_action_pressed("shot1")):
		shootMode = 1
	elif(Input.is_action_pressed("shot2")):
		shootMode = 2
	elif(Input.is_action_pressed("shot3")):
		shootMode = 3


func _physics_process(_delta):
	
	var xDistance = player.xDistance
	var yDistance = -player.yDistance + yOffSet
	var distance = sqrt(pow(xDistance,2) + pow(yDistance,2))
	
	if distance != 0:
		y = ((yDistance/distance) * radius)
		x = (xDistance/distance) * radius

	position = Vector2(x, y - yOffSet)
	


func shoot():
	if canFire == true:

		canFire = false
		match shootMode:
			1:
				normalShot()
			2:
				superFastShot()
			3:
				multiShot()
#shooting modes -----------------------------------------------------------------------------------
func normalShot():
	var bulletSpeed = default_bulletSpeed * 1500
	var fireCooldown = default_fireCooldown* 0.1
	var bulletDamage = default_bulletDamage * 2.5
	var direction = Vector2(x,y)
		
	instantiateBullet(bulletDamage, bulletSpeed, direction, !canPierce)

	yield(get_tree().create_timer(fireCooldown), "timeout")
	canFire = true
		
func superFastShot():
	var bulletSpeed = default_bulletSpeed * 1000
	var fireCooldown = default_fireCooldown * 0.01
	var bulletDamage = default_bulletDamage * 0.25
	
	var direction = Vector2(x,y)	
	
	instantiateBullet(bulletDamage, bulletSpeed, direction, canPierce)

	yield(get_tree().create_timer(fireCooldown), "timeout")
	canFire = true
	
func multiShot():
	
	var bulletSpeed = default_bulletSpeed * 1000
	var fireCooldown = default_fireCooldown* 0.8
	var bulletDamage = default_bulletDamage * 4.5
	var direction = Vector2(x,y)
	var angle
	
	if (x >= 0):
		angle = asin(y/radius)
	else:
		angle = -(PI+asin(y/radius))
	
	var direction2 = Vector2(cos(angle + angleOpening),sin(angle + angleOpening))
	var direction3 = Vector2(cos(angle - angleOpening),sin(angle - angleOpening))
	var direction4 = Vector2(cos(angle + angleOpening*2),sin(angle + angleOpening*2))
	var direction5 = Vector2(cos(angle - angleOpening*2),sin(angle - angleOpening*2))
	var direction6 = Vector2(cos(angle + angleOpening*3),sin(angle + angleOpening*3))
	var direction7 = Vector2(cos(angle - angleOpening*3),sin(angle - angleOpening*3))
	
	instantiateBullet(bulletDamage, bulletSpeed, direction, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction2, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction3, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction4, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction5, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction6, false)
	instantiateBullet(bulletDamage, bulletSpeed, direction7, false)

	yield(get_tree().create_timer(fireCooldown), "timeout")
	canFire = true

func piercingShoot():
	print("piercingShoot")
	
func instantiateBullet(bulletDamage, bulletSpeed, direction, canPierce):
	bullet_instance = bullet.instance()
	
	bullet_instance.bulletDamage = bulletDamage
	bullet_instance.position = get_parent().get_global_position() + position
	bullet_instance.canPierce = canPierce	
	bullet_instance.apply_impulse(Vector2(), direction.normalized() * bulletSpeed)
	
	get_node("/root/Main").add_child(bullet_instance)
