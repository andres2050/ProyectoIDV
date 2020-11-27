extends Node2D

export var canSpawn = true 
export var spawnTime = 1.0

var spawners
var obstacles
var leftDoors
var rightDoors

var enemyCount = 0

var event_ended = false


var scenario
var tilemap
func _ready():
	spawners = get_tree().get_nodes_in_group("spawner")
	
	if (get_tree().get_nodes_in_group("scenario_collisions").size() > 0):
		scenario = get_tree().get_nodes_in_group("scenario_collisions")[0]
	tilemap = get_node("EventDetector")
	
	obstacles = tilemap.get_used_cells_by_id(1)
	leftDoors = tilemap.get_used_cells_by_id(3)
	rightDoors = tilemap.get_used_cells_by_id(5)


func Start_Event():
	if canSpawn: 
		canSpawn = false
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
		Open_doors()
		Clear_obstacles()
		
func Clear_obstacles():
	for i in range(obstacles.size()):
		scenario.set_cellv(obstacles[i],-1)

func Open_doors():
	for i in range(leftDoors.size()):
		scenario.set_cellv(leftDoors[i],-1)
	for i in range(rightDoors.size()):
		scenario.set_cellv(rightDoors[i],-1)
