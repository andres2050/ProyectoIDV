extends TileMap

func _ready():
	print(get_cell(7, -4), get_cell(6, -4), get_cell(7, -3), get_cell(0, 0))
	set_cell(0,-1, -1)
	set_cell(0,0, 0)
	set_cell(0,1, 1)
	set_cell(0,2, 2)
	set_cell(0,3, 3)
	set_cell(0,4, 4)
	set_cell(0,5, 5)
	set_cell(0,6, 6)
	set_cell(0,7, 7)
	set_cell(0,8, 8)
	set_cell(0,9, 9)
	set_cell(0,10, 10)
	set_cell(0,11, 11)
	set_cell(0,12, 12)
	
#	print(get_used_cells())
