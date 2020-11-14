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
var movementDirection = Vector2()
var playerPosition = Vector2(0,0)
var initPosition = Vector2(0,0)
var velocity

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
	movementDirection = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		movementDirection += Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		movementDirection += Vector2(1,0)
	if Input.is_action_pressed("ui_up"):
		movementDirection += Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		movementDirection += Vector2(0,1)

	
func _physics_process(_delta):
	
	if movementDirection.length() >= 0:
		movementDirection = movementDirection.normalized()  * movementSpeed
		movementDirection.y = movementDirection.y * 0.5

		movementDirection = move_and_slide(movementDirection)
		
func damage_health(damage):
	health=health-damage


# get velocity -------------------------------------------------
#		velocity = playerPosition - initPosition
#		initPosition = playerPosition
