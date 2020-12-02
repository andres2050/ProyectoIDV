extends Control

onready var playerNode =  get_tree().get_nodes_in_group("player")[0]
onready var animationPlayer = get_node("ColorRect/DefeatAnimationPlayer")
var canDie = true
var main_node = self

func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	

func _process(_delta):
	if canDie:
		if playerNode.health <= 0:
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
			var children = main_node.get_children()
			for i in range(children.size()):
				if children[i] != self.get_parent():
					children[i].queue_free()

