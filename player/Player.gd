extends KinematicBody2D

var direction = "down" #default
var distanceTangent

var xDistance = 0
var yDistance = 0
var tangent_1 = 0.41421
var tangent_2 = 2.41421

export var movementSpeed = 400
var movementDirection = Vector2()
var playerPosition = Vector2(0,0)
var initPosition = Vector2(0,0)
var velocity

func _process(delta):
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
	#------------------------------------------------------------------------------------------------
	#shooting
	if Input.is_action_pressed("fire"):
		get_node("Weapon").shoot()
	#-----------------------------------------------------------------------------------------------
	#playerMovement
	movementDirection = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		movementDirection += Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		movementDirection += Vector2(1,0)
	if Input.is_action_pressed("ui_up"):
		movementDirection += Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		movementDirection += Vector2(0,1)

	
func _physics_process(delta):
	
	if movementDirection.length() >= 0:
		movementDirection = movementDirection.normalized()  * movementSpeed
		movementDirection.y = movementDirection.y * 0.5

		move_and_slide(movementDirection)
#		if movementDirection.y != 0 and movementDirection.x != 0:
#			move_and_collide(movementDirection)
#			print("a")
#		else:
#			move_and_slide(movementDirection*50)
#			print("b")
#(-0.894427, -0.447214)
#(-0.707107, -0.353553)
#(282.842712, 141.421356)
#(-282.842712, -141.421356)


# get velocity -------------------------------------------------
#		velocity = playerPosition - initPosition
#		initPosition = playerPosition
