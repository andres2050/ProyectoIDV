extends Sprite

var fall_x = 0.5
var fall_y 
var radius = 30
var center
var fall_position
func _ready():
	fall_y = sqrt(1 -pow(fall_x,2))
	center = Vector2(position.x , position.y)
	fall_position = center + Vector2(fall_x, fall_y)* radius
	position.y -= 0

var t=0
func _physics_process(_delta):
	if position.y <= fall_position.y:
		t += 0.1
		position.x += fall_x
		position.y += f(t)
	
	
func f(x):
	return x-(3)
