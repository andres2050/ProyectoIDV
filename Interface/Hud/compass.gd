extends Control

var target
var player
var direction

onready var nail = get_node("nail")

var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	target = main_node.get_node("compass_target")
	player = main_node.get_node("YSort/Player")
	

func _process(_delta):
	nail.look_at(target.position - player.position)


func _on_in_body_entered(body):
	if body.is_in_group("player"):
		target.queue_free()
		queue_free()
