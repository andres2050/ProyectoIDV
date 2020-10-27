extends TextureProgress

onready var player = get_node("/root/Main/Scenario/Player")

func _process(delta):
	value = player.health
