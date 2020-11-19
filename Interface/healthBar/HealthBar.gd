extends TextureProgress

onready var player = get_tree().get_nodes_in_group("player")[0]

func _process(_delta):
	value = player.health
