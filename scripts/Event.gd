extends Node2D

export var canSpawn = true 
export var spawnTime = 1
export(Array, NodePath) var spawners
export(Array, Vector2) var doors


onready var scenario = get_node("/root/Main/Scenario")
func Start_Event():
	if canSpawn: 
		canSpawn = false
		for i in range(spawners.size()):
			get_node(spawners[i]).canSpawn = true
			get_node(spawners[i]).spawnRate = spawnTime
			
		for i in range(doors.size()):
			scenario.set_cellv(doors[i],4)
