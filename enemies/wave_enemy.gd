extends KinematicBody2D

export var movement_speed = 380

onready var target
var direction = Vector2()
var distance = 0
var isPaused = true

var path_to_event

func _process(_delta):
	direction.y = target.y - get_global_position().y
	direction.x = target.x - get_global_position().x
	
	distance = sqrt(pow(direction.y,2)*2 + pow(direction.x, 2))

	
var move

func _physics_process(_delta):
	if distance > movement_speed*2 or !isPaused:
		move = direction.normalized()
		$AnimatedSprite.flip_h = move.x < 0	
		move = move_and_slide(move*movement_speed)

func resume():
	isPaused = false
