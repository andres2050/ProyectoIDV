extends Node2D

var main_node = self

var warehouse_walls
func _ready():
	modulate.a = 1
	while (main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	warehouse_walls = main_node.get_node("YSort/warehouse_walls")


var is_in = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		is_in = true
		while (is_in and modulate.a > 0):
			modulate.a -= 0.01
			yield(get_tree().create_timer(0.01),"timeout")
		


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		is_in = false
		while (!is_in and modulate.a < 1):
			modulate.a += 0.01
			yield(get_tree().create_timer(0.01),"timeout")
		
