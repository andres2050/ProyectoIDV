extends KinematicBody2D

export var health = 15
export var enemyMovementSpeed = 450
export var attackDistance = 200
onready var defaultMovementSpeed = enemyMovementSpeed
export var damage = 10

var isdead = false
var canDamage = true
var canDie = true

var sfx_path = "res://sound/sfx/enemy/"
var sfx_dash = load(sfx_path + "enemy_dash.ogg")
var sfx_die = load(sfx_path + "enemy_die.wav")

var path_to_event
var animation_player
var event
var player

var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	animation_player = get_node("AnimationPlayer")
	event = get_node(path_to_event)
#export var path_to_player: NodePath
	player = get_tree().get_nodes_in_group("player")[0]
	

func _process(_delta):
	if (enemyMovementSpeed < defaultMovementSpeed and !isdead):
		enemyMovementSpeed += 15
		
	sfx.volume_db = (40*main_node.sfx_volume)-40

onready var sfx = get_node("sfx_player")

var playerPosition
var enemyPosition
var canMove = true
var direction
var distance
func _physics_process(_delta):
	if canMove:
		attackMoment = 0
		playerPosition = player.get_global_position()
		enemyPosition = get_global_position()
		
		direction = Vector2(playerPosition.x - enemyPosition.x , (playerPosition.y - enemyPosition.y) * 2)
		
		distance = sqrt((direction.x * direction.x) + (direction.y * direction.y))
		
		if (distance < attackDistance):
			sfx.stream = sfx_dash
			sfx.play()
			canMove = false
		else:
			move(direction.normalized())
	else:
		attack(direction.normalized())
		
func move(movement):
	movement = movement * enemyMovementSpeed
	movement.y = movement.y * 0.5
	movement = move_and_slide(movement)
	$AnimatedSprite.flip_h = movement.x > 0

var attackMoment = 0
var attackVelocity

func attack(movement):
	attackMoment += 0.02
	if attackMoment <= 1:
		attackVelocity = sqrt(-attackMoment +1 )*defaultMovementSpeed*2
		movement = movement*attackVelocity
		movement.y = movement.y *0.5
		movement = move_and_slide(movement)
		$AnimatedSprite.flip_h = movement.x > 0	
	else:
		canMove = true
		

func damage_health(incoming_damage, knockbackForce):
		
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
		sfx.stream = sfx_die
		sfx.play()
		canDie = false
		animation_player.play("Die")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		event.enemyCount -= 1
		queue_free()

func die_quiet():	
	if canDie:
		canDie = false
		animation_player.play("Die")
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		event.enemyCount -= 1
		queue_free()

