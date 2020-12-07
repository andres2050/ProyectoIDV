extends Node2D

var player
var follow_player = true
func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	follow_player = false
	get_node("AnimationPlayer").play("fade")
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()

func _process(_delta):
	if follow_player:
		look_at(player.position)
