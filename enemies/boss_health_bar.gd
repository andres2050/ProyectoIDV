extends TextureProgress

onready var boss = get_node("../../../")
var isSpawning = true
func _ready():
	value = 0

func _process(_delta):
	if isSpawning:
		if value < boss.health:
			value += 1
		else:
			isSpawning = false
	else:
		value = boss.health
