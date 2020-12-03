extends Node2D

export (String,"", "ghost", "boss", "ghost_fast") var spawnOf
var enemy

export var maxEnemies = 10
export var canSpawn = true
var spawnCount = 0
var spawnRate = 1

var event
var path_to_event = "/root/"
var scenario
var main_node = self
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
		
	if (get_tree().get_nodes_in_group("Scenario").size() >0):
		scenario = get_tree().get_nodes_in_group("Scenario")[0]
	event = get_node("../..")
	path_to_event += (main_node.get_name() + "/Events/" + event.get_name())
	enemy = load("res://enemies/" + spawnOf + ".tscn")
#	match spawnOf:
#		"ghost":
#			enemy = preload("res://enemies/ghost.tscn")
#		"boss":
#			enemy = preload("res://enemies/boss.tscn")
#		"":
#			pass

func _process(_delta):
	if canSpawn and spawnCount < maxEnemies:
		canSpawn = false
		
		spawnEnemy()
		yield(get_tree().create_timer(spawnRate), "timeout")
		canSpawn = true
	if (event.enemyCount == 0 and event.canStart == false):
		event.EndEvent()

func spawnEnemy():
	spawnCount +=1
	event.enemyCount +=1
	
	var enemy_instance = enemy.instance()
	
	enemy_instance.position = get_global_position()
	enemy_instance.path_to_event = path_to_event
	
	scenario.add_child(enemy_instance)
