extends Node2D

export var canStart = true 
export var spawnTime = 1.0
export(String, "","Start_menu","Ambiental_city", "Combat", "In_Station", "Final_Boss") var soundtrack

export(String, "","Start_menu","Ambiental_city", "Combat", "In_Station") var exit_soundtrack
var obstacle = preload("res://prefabs/SceneObjects/obstacles/obstacle.tscn")
var obstacle_instances=[]

var spawners
var obstacles
var obstacles_position = []
var leftDoors
var rightDoors

export(bool) var save_at_end = true

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
	aux = get_tree().get_nodes_in_group("Scenario")
	if (aux.size() > 0):
		scenario = aux[0]
	tilemap = get_node("EventDetector")
	tilemap.visible = false
	obstacles = tilemap.get_used_cells_by_id(1)
	leftDoors = tilemap.get_used_cells_by_id(3)
	rightDoors = tilemap.get_used_cells_by_id(5)
	for i in range(obstacles.size()):
		obstacles_position.push_back(tilemap.map_to_world(obstacles[i]))
		obstacle_instances.push_back(obstacle.instance())
		obstacle_instances[i].position = obstacles_position[i]
		

func Start_Event():
	if canStart: 
		canStart = false
		if soundtrack != "":
			bgm_player.change_soundtrack(soundtrack)
		for i in range(spawners.size()):
			spawners[i].canSpawn = true
			spawners[i].spawnRate = spawnTime
			
		for i in range(obstacles.size()):
			scenario.add_child(obstacle_instances[i])
			yield(get_tree().create_timer(0.01),"timeout")
#		for i in range(leftDoors.size()):
#			scenario.set_cellv(leftDoors[i],0)
#			tilemap.set_cellv(leftDoors[i],-1)
#		for i in range(rightDoors.size()):
#			scenario.set_cellv(rightDoors[i],0)
#			tilemap.set_cellv(rightDoors[i],-1)

func EndEvent():
	if event_ended == false:
		event_ended = true
		if exit_soundtrack != "":
			bgm_player.change_soundtrack(exit_soundtrack)
		Open_doors()
		Clear_obstacles()
		if save_at_end:
			main_node.refresh_states()
		
func Clear_obstacles():
	for i in range(obstacle_instances.size()):
		obstacle_instances[i].queue_free()
		yield(get_tree().create_timer(0.01),"timeout")

func Open_doors():
	for i in range(leftDoors.size()):
		scenario.set_cellv(leftDoors[i],-1)
	for i in range(rightDoors.size()):
		scenario.set_cellv(rightDoors[i],-1)
