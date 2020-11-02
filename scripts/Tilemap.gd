extends TileMap

func _ready():
	set_cell(0,-1, -1)
	set_cell(0,0, 0)
	#floor
	set_cell(0,1, 1)
	#detection_floor
	set_cell(0,2, 2)
	#wall
	set_cell(0,3, 3)
	#pillar
	set_cell(0,4, 4)
	#door_left_closed
	set_cell(0,5, 5)
	#door_left_open
	set_cell(0,6, 6)
	#door_right_closed
	set_cell(0,7, 7)
	#door_right_open
	set_cell(0,8, 8)
	#downwall
	set_cell(0,9, 9) 
	#upwall
	set_cell(0,10, 10) 
	#left wall
	set_cell(0,11, 11) 
	#right wall
	set_cell(0,12, 12)
	set_cell(0,13, 13)
	
#	print(get_used_cells())
