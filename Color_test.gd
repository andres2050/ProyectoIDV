extends Sprite


export(float,0,1) var alfa = 1
export(float,0,1) var red = 1
export(float,0,1) var blue = 1
export(float,0,1) var green = 1


func _process(delta):
	modulate.a = alfa
	modulate.r = red
	modulate.b = blue
	modulate.g = green
