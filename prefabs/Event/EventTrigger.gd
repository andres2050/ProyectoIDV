extends Area2D


#export var path_to_enemySpawn1: NodePath
#export var path_to_enemySpawn2: NodePath

func _on_EventTrigger_body_entered(body):
	var eventParent = body.get_parent()
	if (eventParent.is_in_group("Event")):
		eventParent.Start_Event()
