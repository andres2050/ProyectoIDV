extends Control

onready var playerNode =  get_node("/root/Main/Scenario/Player")

func _process(_delta):
	if playerNode.health <= 0:
		get_tree().paused = true
		visible = true
