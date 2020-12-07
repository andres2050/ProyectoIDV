extends KinematicBody2D

export var health = 200
export var enemyMovementSpeed = 450
export var attack_range = 200
onready var defaultMovementSpeed = enemyMovementSpeed
export var damage = 10

var jump_shade = preload("res://enemies/boss/jump_shade.tscn")
var jump_shade_instance

var dash_shade = preload("res://enemies/boss/dash_shade.tscn")
var dash_shade_instance

var isdead = false
var canDamage = true
var canDie = true

var animation_player
var player
var path_to_event = ""
var event
onready var jump_hitbox = get_node("jump_hitbox")
onready var dash_hitbox = get_node("dash_hitbox")

var phase = 0
var isAttacking = true

func _ready():
	event = get_node(path_to_event)
	get_node("CollisionPolygon2D").queue_free()
	animation_player = get_node("AnimationPlayer")
	player = get_tree().get_nodes_in_group("player")[0]
	animation_player.play("Appearance")
	yield(get_tree().create_timer(animation_player.current_animation_length +1),"timeout")
	get_node("Hurtbox/CollisionShape2D").disabled = false
	isAttacking = false

func _process(_delta):
	if !isAttacking and canDie:
		match phase:
			0:
				dash_attack()
				phase += 1
			1:
				dash_attack()
				phase += 1
			2:
				jump_attack()
				phase += 1
			3:
				dash_attack()
				phase += 1
			4:
				jump_attack()
				phase += 1
			5:
				isAttacking = true
				yield(get_tree().create_timer(2),"timeout")
				phase = 0
				isAttacking = false
	else:
		pass

#func _physics_process(_delta):
#	if Input.is_action_just_pressed("shot1") and !isAttacking:
#		isAttacking = true
#		jump_attack()
#	if Input.is_action_just_pressed("shot2") and !isAttacking:
#		isAttacking = true
#		dash_attack()
	
func move(_movement):
	pass

var attack_t = .0
var attack_position = Vector2()
var attack_distance = .0

func jump_attack():
	isAttacking = true
	jump_shade_instance = jump_shade.instance()
	jump_shade_instance.player = player
	get_parent().add_child(jump_shade_instance)
	yield(get_tree().create_timer(0.5),"timeout")
	attack_position = player.position - position
	attack_distance = sqrt(pow(attack_position.x,2) + pow(attack_position.y , 2) )
	attack_t = 0
	var height = .0
	var jump = Vector2()
	while(attack_t < attack_distance):
		height = (2 * attack_t) - attack_distance
		jump = Vector2(attack_position.x/30 , (attack_position.y + 2*height)/30)
		position += jump
		attack_t += attack_distance/30
		yield(get_tree().create_timer(0.01),"timeout")
	yield(get_tree().create_timer(0.05),"timeout")
	jump_hitbox.disabled = false
	yield(get_tree().create_timer(0.1),"timeout")
	jump_hitbox.disabled = true
	isAttacking = false

func dash_attack():
	isAttacking = true
	dash_shade_instance = dash_shade.instance()
	dash_shade_instance.position = position
	dash_shade_instance.player = player
	get_parent().add_child(dash_shade_instance)
	yield(get_tree().create_timer(0.5),"timeout")
	attack_position = (player.position - position)*1.2
	attack_distance = sqrt(pow(attack_position.x,2) + pow(attack_position.y , 2) )
	attack_t = 0
	dash_hitbox.disabled = false
	var speed= .0
	var direction = attack_position.normalized()
	while(attack_t <= attack_distance):
		speed = (attack_distance/20) *(-(2*attack_t/attack_distance)+2)
		position += direction*speed
		attack_t += attack_distance/20
		yield(get_tree().create_timer(0.01),"timeout")
	yield(get_tree().create_timer(0.1),"timeout")
	dash_hitbox.disabled = true
	isAttacking = false

func damage_health(incoming_damage, _knockbackForce):
		
	health=health - incoming_damage
#	var move = move_and_collide(direction * knockbackForce)
	animation_player.play("ReceiveDamage")
	if health <= 0:
		isdead = true
		canDamage = false
		enemyMovementSpeed = 0
		get_node("Hurtbox/CollisionShape2D").queue_free()
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
		die()
	
func damage_player():
	if canDamage == true:
		pass


func die():	
	if canDie:
		canDie = false
		animation_player.play("boss_die")
		event.EndEvent()
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")


