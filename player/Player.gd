extends KinematicBody2D

var direction = "down" #default
var distanceTangent

var xDistance = 0
var yDistance = 0
var tangent_1 = 0.41421
var tangent_2 = 2.41421

export var maxHealth = 100
onready var health = maxHealth
export var movementSpeed = 400
export(float,0,1) var healAmount = 0.7
var movementDirection = Vector2()
var playerPosition = Vector2(0,0)
var initPosition = Vector2(0,0)
var velocity
var canMove = true
var healCharges = 1

func _process(_delta):
	# rotation start -------------------------------------------------------------------------------
	
	var mousePosition = get_global_mouse_position()
	playerPosition = get_global_position()
	
	xDistance = mousePosition.x - playerPosition.x
	yDistance = (-mousePosition.y) - (-playerPosition.y)
	if xDistance != 0:
		distanceTangent = yDistance / xDistance

	if yDistance >= 0:		
		if distanceTangent < tangent_1 and distanceTangent > 0:
				direction = "right"
		elif distanceTangent > tangent_1 and distanceTangent < tangent_2:
				direction = "rightUp"
		elif distanceTangent > tangent_2 or distanceTangent < -tangent_2:
				direction = "up"
		elif distanceTangent > -tangent_2 and distanceTangent < -tangent_1:
				direction = "leftUp"
		elif distanceTangent > -tangent_1 and distanceTangent < 0:
				direction = "left"
	else:
		if distanceTangent < tangent_1 and distanceTangent > 0:
				direction = "left"
		elif distanceTangent > tangent_1 and distanceTangent < tangent_2:
				direction = "leftDown"
		elif distanceTangent > tangent_2 or distanceTangent < -tangent_2:
				direction = "down"
		elif distanceTangent > -tangent_2 and distanceTangent < -tangent_1:
				direction = "rightDown"
		elif distanceTangent > -tangent_1 and distanceTangent < -0.001:
				direction = "right"
	
	$AnimatedSprite.animation = direction
	#-----------------------------------------------------------------------------------------------
	#playerMovement
	if canMove:
		movementDirection = Vector2()
		if Input.is_action_pressed("ui_left"):
			movementDirection += Vector2(-1,0)
		if Input.is_action_pressed("ui_right"):
			movementDirection += Vector2(1,0)
		if Input.is_action_pressed("ui_up"):
			movementDirection += Vector2(0,-1)
		if Input.is_action_pressed("ui_down"):
			movementDirection += Vector2(0,1)
	#heal
		if Input.is_action_just_pressed("heal") and healCharges > 0:
			heal()
			
func heal():
	healCharges -= 1
	for _i in range(healAmount*maxHealth):
		health += 1
		yield(get_tree().create_timer(0.03),"timeout")
		if health >= maxHealth:
			health = maxHealth
			break
			
			
func _physics_process(_delta):
	
	if movementDirection.length() >= 0:
		movementDirection = movementDirection.normalized()  * movementSpeed
		var move = Vector2(movementDirection.x , movementDirection.y * 0.5)
		move = move_and_slide(move)
		
func damage_health(damage):
	health=health-damage

func pickup_item(pickup):
	match pickup:
		"":
			pass
		"heal":
			if healCharges < 3:
				healCharges += 1
			else:
				heal()

# get velocity -------------------------------------------------
#		velocity = playerPosition - initPosition
#		initPosition = playerPosition
