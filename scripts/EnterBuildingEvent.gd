extends Node2D

onready var animation_player = get_node("/root/Main/ScreenCanvas/Fading/FadingPlayer")
onready var event = get_parent()

var isInEvent =false
func _process(delta):
	if (!event.canSpawn and !isInEvent):
		isInEvent = true
		animation_player.play("EnterBuilding")
		var enemies =  get_tree().get_nodes_in_group("enemy")
		
		for i in range(enemies.size()):
			enemies[i].queue_free()
