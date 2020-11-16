extends Node2D

export var canSpawn = true 
export var spawnTime = 1.0

export(Array, NodePath) var spawners
export(Array, Vector2) var doors
var leftDoors
var rightDoors

var enemyCount = 0

var event_ended = false


var scenario
var tilemap
func _ready():
	scenario = get_node("/root/Main/Scenario")
	tilemap = get_node("EventTrigger")
	
	leftDoors = tilemap.get_used_cells_by_id(5)
	rightDoors = tilemap.get_used_cells_by_id(7)


func Start_Event():
	if canSpawn: 
		canSpawn = false
		for i in range(spawners.size()):
			get_node(spawners[i]).canSpawn = true
			get_node(spawners[i]).spawnRate = spawnTime
			
		for i in range(leftDoors.size()):
			scenario.set_cellv(leftDoors[i],4)
			tilemap.set_cellv(leftDoors[i],-1)
		for i in range(rightDoors.size()):
			scenario.set_cellv(rightDoors[i],6)
			tilemap.set_cellv(rightDoors[i],-1)

func EndEvent():
	if event_ended == false:
		event_ended = true
		for i in range(doors.size()):
			scenario.set_cellv(doors[i], -1)
