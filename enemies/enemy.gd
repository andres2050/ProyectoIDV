extends KinematicBody2D
export(float, 0,1) var alfa = 1
export(float, 0,1) var red = 1
export(float, 0,1) var blue = 1
export(float, 0,1) var green = 1

export var health = 15
export var enemyMovementSpeed = 300
onready var defaultMovementSpeed = enemyMovementSpeed
export var damage = 10

var isdead = false
var canDamage = true
var canDie = true

var path_to_event

var animation_player
var event
var player

func _ready():
	alfa = 1
	red = 1
	blue = 1
	green = 1
	animation_player = get_node("AnimationPlayer")
	event = get_node(path_to_event)
#export var path_to_player: NodePath
	player = get_tree().get_nodes_in_group("player")[0]

func _process(_delta):
	modulate.a = alfa
	modulate.r = red
	modulate.b = blue
	modulate.g = green
	if (enemyMovementSpeed < defaultMovementSpeed and !isdead):
		enemyMovementSpeed += 15

var playerPosition
var enemyPosition
var canMove = true
var direction
export var attackDistance = 200
var distance
func _physics_process(_delta):
	if canMove:
		attackMoment = 0
		playerPosition = player.get_global_position()
		enemyPosition = get_global_position()
		
		direction = Vector2(playerPosition.x - enemyPosition.x , (playerPosition.y - enemyPosition.y) * 2)
		
		distance = sqrt((direction.x * direction.x) + (direction.y * direction.y))
		
		if (distance < attackDistance):
			canMove = false
		else:
			move(direction.normalized())
	else:
		attack(direction.normalized())
		
func move(movement):
	movement = movement * enemyMovementSpeed
	movement.y = movement.y * 0.5
	movement = move_and_slide(movement)
	$AnimatedSprite.flip_h = movement.x < 0

var attackMoment = 0
var attackVelocity

func attack(movement):
	attackMoment += 0.02
	if attackMoment <= 1:
		attackVelocity = sqrt(-attackMoment +1 )*defaultMovementSpeed*2
		movement = movement*attackVelocity
		movement.y = movement.y *0.5
		movement = move_and_slide(movement)
		$AnimatedSprite.flip_h = movement.x < 0	
	else:
		canMove = true
		

func damage_health(incoming_damage, knockbackForce):
	
	modulate.a =0.5
		
	health=health - incoming_damage
#	var move = move_and_collide(direction * knockbackForce)
	if canMove:
		enemyMovementSpeed -= knockbackForce*30
	animation_player.play("ReceiveDamage")
	if health <= 0:
		isdead = true
		canDamage = false
		enemyMovementSpeed = 0
		get_node("CollisionPolygon2D").queue_free()
		get_node("Hurtbox/CollisionShape2D").queue_free()
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		die()
	
func damage_player():
	if canDamage == true:
		pass


func die():	
	if canDie:
		canDie = false
		red = 0.5
		green = 0.5
		animation_player.play("Die")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		event.enemyCount -= 1
		queue_free()


