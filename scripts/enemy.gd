extends KinematicBody2D

export var health = 15
export var enemyMovementSpeed = 300

var damageTaken= 0 #damageTest
var initTime = 0
var time = 0
#export var path_to_player: NodePath

onready var player = get_node("/root/Main/Scenario/Player")

func _process(delta):
	
	if damageTaken <= 0:
		initTime = OS.get_unix_time()
	if damageTaken > 100:
		print(OS.get_unix_time() - initTime)
		damageTaken = -1
	#damageTest
	
	var playerPosition = player.get_global_position()
	var enemyPosition = get_global_position()
	
	var xDistance = playerPosition.x - enemyPosition.x
	var yDistance = (playerPosition.y - enemyPosition.y) *2
	
	var movement = Vector2(xDistance,yDistance)

	if movement.length() > 0: 		
		movement = movement.normalized() * enemyMovementSpeed
		movement.y = movement.y * 0.5
		move_and_slide(movement)
#		position += movement * delta
		$AnimatedSprite.flip_h = xDistance < 0
		
	if health <= 0:
		die()

func damage_health(damage):
	health=health-damage
	
	damageTaken += damage #damageTest

func die():
	queue_free()


