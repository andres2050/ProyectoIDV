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

var sfx_path = "res://sound/sfx/boss/"
var sfx_dash = load(sfx_path + "boss_dash.ogg")
var sfx_jump = load(sfx_path + "jump.wav")
var sfx_death = load(sfx_path + "bossDeath.wav")

onready var sfx = get_node("sfx_player")

var isdead = false
var canDamage = true
var canDie = true

var animation_player
var player
var path_to_event = ""
var event
onready var jump_hitbox = get_node("jump_hitbox")
onready var dash_hitbox = get_node("dash_hitbox")
onready var sprite = get_node("AnimatedSprite2")
var phase = 0
var isAttacking = true

var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	event = get_node(path_to_event)
	get_node("CollisionPolygon2D").queue_free()
	animation_player = get_node("AnimationPlayer")
	player = get_tree().get_nodes_in_group("player")[0]
	animation_player.play("Appearance")
	yield(get_tree().create_timer(animation_player.current_animation_length +1),"timeout")
	get_node("Hurtbox/CollisionShape2D").disabled = false
	isAttacking = false
	sprite.set_animation("standing")

func _process(_delta):
	if !isAttacking and canDie:
		sprite.set_animation("standing")
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
	$AnimatedSprite2.flip_h = attack_position.x > 0
	sfx.volume_db = (60*sqrt(main_node.sfx_volume))-60
#func _physics_process(_delta):
#	if Input.is_action_just_pressed("shot1") and !isAttacking:
#		isAttacking = true
#		jump_attack()
#	if Input.is_action_just_pressed("shot2") and !isAttacking:
#		isAttacking = true
#		dash_attack()
	

var attack_t = .0
var attack_position = Vector2()
var attack_distance = .0

func jump_attack():
	sprite.set_animation("prejump")
	isAttacking = true
	jump_shade_instance = jump_shade.instance()
	jump_shade_instance.player = player
	get_parent().add_child(jump_shade_instance)
	yield(get_tree().create_timer(0.5),"timeout")
	sprite.set_animation("jump")
	attack_position = player.position - position
	attack_distance = sqrt(pow(attack_position.x,2) + pow(attack_position.y , 2) )
	attack_t = 0
	var height = .0
	var jump = Vector2()
	while(attack_t < attack_distance):
		height = (2 * attack_t) - attack_distance
		jump = Vector2(attack_position.x/30 , (attack_position.y + 3*height)/30)
		position += jump
		attack_t += attack_distance/30
		yield(get_tree().create_timer(0.01),"timeout")
	yield(get_tree().create_timer(0.05),"timeout")
	sprite.set_animation("prejump")
	sfx.stream = sfx_jump
	sfx.play()
	jump_hitbox.disabled = false
	yield(get_tree().create_timer(0.1),"timeout")
	jump_hitbox.disabled = true
	isAttacking = false
	

func dash_attack():
	sprite.set_animation("prepunch")
	isAttacking = true
	dash_shade_instance = dash_shade.instance()
	dash_shade_instance.position = position
	dash_shade_instance.player = player
	get_parent().add_child(dash_shade_instance)
	yield(get_tree().create_timer(0.5),"timeout")
	sprite.set_animation("punch")
	sfx.stream = sfx_dash
	sfx.play()
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
		sfx.stream = sfx_death
		sfx.play()
		canDie = false
		animation_player.play("boss_die")
		event.EndEvent()
		yield(get_tree().create_timer(animation_player.current_animation_length),"timeout")
