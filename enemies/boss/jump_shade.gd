extends Sprite

var player
var moving = true
func _ready():
	get_node("AnimationPlayer").play("jump_indicator")
	yield(get_tree().create_timer(0.5),"timeout")
	moving = false
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()
	
func _process(_delta):
	if moving:
		position = player.position
		
