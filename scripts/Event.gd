extends Node2D

export var canSpawn = true 
export var spawnTime = 1
export(Array, NodePath) var spawners

func Start_Event():
	if canSpawn: 
		canSpawn = false
		for i in range(spawners.size()):
			get_node(spawners[i]).canSpawn = true
			get_node(spawners[i]).spawnRate = spawnTime
