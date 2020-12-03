extends Node2D

export var canStart = true 
export var spawnTime = 1.0
export(String, "","Start_menu","Ambiental_city", "Combat") var soundtrack

var spawners
var obstacles
var leftDoors
var rightDoors

var enemyCount = 0

var event_ended = false

var bgm_player
var scenario
var tilemap

var main_node = self
func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	
	while (main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	spawners = get_node("Spawners").get_children()
	var aux = get_tree().get_nodes_in_group("bgm_player")
	if(aux.size() > 0):
		bgm_player = aux[0]
	aux = get_tree().get_nodes_in_group("scenario_collisions")
	if (aux.size() > 0):
		scenario = aux[0]
	tilemap = get_node("EventDetector")
	tilemap.visible = false
	obstacles = tilemap.get_used_cells_by_id(1)
	leftDoors = tilemap.get_used_cells_by_id(3)
	rightDoors = tilemap.get_used_cells_by_id(5)

func Start_Event():
	if canStart: 
		canStart = false
		bgm_player.change_soundtrack(soundtrack)
		for i in range(spawners.size()):
			spawners[i].canSpawn = true
			spawners[i].spawnRate = spawnTime
			
		for i in range(obstacles.size()):
			scenario.set_cellv(obstacles[i],0)
			tilemap.set_cellv(obstacles[i],-1)
		for i in range(leftDoors.size()):
			scenario.set_cellv(leftDoors[i],0)
			tilemap.set_cellv(leftDoors[i],-1)
		for i in range(rightDoors.size()):
			scenario.set_cellv(rightDoors[i],0)
			tilemap.set_cellv(rightDoors[i],-1)

func EndEvent():
	if event_ended == false:
		event_ended = true
		bgm_player.change_soundtrack("Ambiental_city")
		Open_doors()
		Clear_obstacles()
		main_node.refresh_states()
		
func Clear_obstacles():
	for i in range(obstacles.size()):
		scenario.set_cellv(obstacles[i],-1)

func Open_doors():
	for i in range(leftDoors.size()):
		scenario.set_cellv(leftDoors[i],-1)
	for i in range(rightDoors.size()):
		scenario.set_cellv(rightDoors[i],-1)
