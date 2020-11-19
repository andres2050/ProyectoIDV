extends KinematicBody2D

export var health = 15
export var enemyMovementSpeed = 300
onready var defaultMovementSpeed = enemyMovementSpeed
export var damage = 10

var path_to_event
onready var event = get_node(path_to_event)
#export var path_to_player: NodePath

onready var player = get_node("/root/Main/Scenario/Player")
func _process(_delta):
	if enemyMovementSpeed < defaultMovementSpeed:
		enemyMovementSpeed += 15

func _physics_process(_delta):
	
	var playerPosition = player.get_global_position()
	var enemyPosition = get_global_position()
	
	var xDistance = playerPosition.x - enemyPosition.x
	var yDistance = (playerPosition.y - enemyPosition.y) *2
	
	var movement = Vector2(xDistance,yDistance)

	if movement.length() > 0: 		
		movement = movement.normalized() * enemyMovementSpeed
		movement.y = movement.y * 0.5
		movement = move_and_slide(movement)
#		position += movement * delta
		$AnimatedSprite.flip_h = xDistance < 0
		
	if health <= 0:
		die()

func damage_health(incoming_damage, knockbackForce):
	health=health - incoming_damage
#	var move = move_and_collide(direction * knockbackForce)
	enemyMovementSpeed -= knockbackForce*30

func die():
	event.enemyCount -= 1
	queue_free()


