extends KinematicBody2D

var direction = "down" #default
var distanceTangent = 0

var xDistance = 0
var yDistance = 0
var tangent_1 = 0.41421
var tangent_2 = 2.41421

var sfx_path = "res://sound/sfx/player/"
var sfx_dash = load(sfx_path + "player_dash.ogg")
var sfx_heal = load(sfx_path + "heal.ogg")
var sfx_pickup = load(sfx_path + "pickup.wav")

export var maxHealth = 100
onready var health = maxHealth
export var movementSpeed = 400
onready var animation_player = get_node("AnimationPlayer")
export(float,0,1) var healAmount = 0.7
var movementDirection = Vector2()
var playerPosition = Vector2(0,0)
var initPosition = Vector2(0,0)
var velocity
var canMove = true
var healCharges = 1
var dash_distance = 1300
var canDash = false

onready var sfx = get_node("sfx_player")

var b = .0
var a = .0
var dash = Vector2()
var isDashing = false

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
				direction = "rightUp"
		elif distanceTangent > -tangent_1 and distanceTangent < 0:
				direction = "right"
	else:
		if distanceTangent < tangent_1 and distanceTangent > 0:
				direction = "right"
		elif distanceTangent > tangent_1 and distanceTangent < tangent_2:
				direction = "rightDown"
		elif distanceTangent > tangent_2 or distanceTangent < -tangent_2:
				direction = "down"
		elif distanceTangent > -tangent_2 and distanceTangent < -tangent_1:
				direction = "rightDown"
		elif distanceTangent > -tangent_1 and distanceTangent < -0.001:
				direction = "right"
	
	$AnimatedSprite.flip_h =  xDistance < 0
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
	#dash ----------------------------------------------------------------------------
		if Input.is_action_just_pressed("dash") and canDash:
			sfx.stream = sfx_dash
			sfx.play()
			canMove = false
			movementDirection = Vector2()
			var x = xDistance
			var y = -yDistance
			var h2 = sqrt(pow(x,2) + pow(2*y,2))
			if h2 == 0 :
				h2 =0.001
			b = (2*y) / (h2*2)
			if y == 0 :
				y =0.001
			a = x*b/y
			t+=0.04
			isDashing = true
			
	#heal ----------------------------------------------------------------------------
	if !isHealing:
		if Input.is_action_just_pressed("heal") and healCharges > 0:
			heal()

var isHealing = false
func heal():
	if health < maxHealth:
		sfx.stream = sfx_heal
		sfx.play()
		healCharges -= 1
		isHealing = true
		for _i in range(healAmount*maxHealth):
			if health <=0:
				isHealing = false
				break
			health += 1
			yield(get_tree().create_timer(0.025),"timeout")
			if health >= maxHealth :
				health = maxHealth
				isHealing = false
				break
		isHealing = false
	
func stop_moving():
	while(isDashing):
		yield(get_tree().create_timer(0.1),"timeout")
	canMove = false
	movementDirection = Vector2(0,0)
			
var move = Vector2()

var t = 0
func _physics_process(_delta):
	move = Vector2(0,0)
	if movementDirection.length() > 0:
		$AnimatedSprite.playing = true
		movementDirection = movementDirection.normalized()  * movementSpeed
		move = Vector2(movementDirection.x , movementDirection.y * 0.5)
		move = move_and_slide(move)
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
		
	if isDashing:
		if t >0 and t<1:
			canDash = false
			dash = Vector2(a,b) * (dash_distance)*sqrt(-t+1)
			dash = move_and_slide(dash)
			t += 0.04
		else:
			isDashing = false
			canMove = true
			yield(get_tree().create_timer(0.4),"timeout")
			canDash = true
			t=0
		
func damage_health(damage):
	animation_player.play("receive_damage_animation")
	health=health-damage

func receive_damage(enemy_position):
	health= health -5
	var hitForce = 500
	canMove = false
	canDash = false
	isDashing = false
	t=0
	movementDirection = Vector2()
	var moment = .0
	var hit_direction = (position - enemy_position).normalized()
	hit_direction.y *= 0.5
	var hit
	while(moment < 1):
		hit = hit_direction*sqrt(-moment+1)*hitForce
		hit = move_and_slide(hit)
		moment+=0.04
		yield(get_tree().create_timer(0.01),"timeout")
	canMove = true
	canDash = true

func pickup_item(pickup):
	sfx.stream = sfx_pickup
	sfx.play()
	match pickup:
		"":
			pass
		"heal":
			if healCharges < 3:
				healCharges += 1
			else:
				heal()
				healCharges +=1
		"weapon":
			upgrade_weapon()
		"dash":
			unlock_dash()
			
func upgrade_weapon():
	var weapon = get_node("Weapon")
	if weapon.weapon_level < 4:
		weapon.interface.show_next_ability()
		weapon.upgrade_weapon()
	
func unlock_dash():
	canDash = true
	var weapon = get_node("Weapon")
	weapon.interface.show_dash_ability()
	get_node("../../").refresh_states()

# get velocity -------------------------------------------------
#		velocity = playerPosition - initPosition
#		initPosition = playerPosition
