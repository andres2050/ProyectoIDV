extends Control

onready var playerNode =  get_tree().get_nodes_in_group("player")[0]
onready var animationPlayer = get_node("ColorRect/DefeatAnimationPlayer")
var canDie = true
func _process(_delta):
	if playerNode.health <= 0 and canDie:
		canDie = false
		get_tree().paused = true
		visible = true
		animationPlayer.play("DeadScreen")
		yield(get_tree().create_timer(2),"timeout")
		get_node("ColorRect2").visible = true
		get_node("Buttons").visible = true
		get_node("Label").visible = true
		yield(get_tree().create_timer(1),"timeout")
		get_node("ColorRect2").visible = false

