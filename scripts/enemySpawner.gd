extends Node2D

export (String, "", "ghost", "boss") var spawnOf
var enemy

export var maxEnemies = 10
export var canSpawn = true
var spawnCount = 0
var spawnRate = 1


func _ready():
	match spawnOf:
		"ghost":
			enemy = preload("res://prefabs/enemies/ghost.tscn")
		"boss":
			enemy = preload("res://prefabs/enemies/boss.tscn")
			

func _process(delta):
	
	if canSpawn and spawnCount < maxEnemies:
		canSpawn = false
		
		spawnEnemy()
		yield(get_tree().create_timer(spawnRate), "timeout")
		canSpawn = true
	

func spawnEnemy():
	spawnCount +=1
	
	var enemy_instance = enemy.instance()
	enemy_instance.position = get_global_position()
	get_node("/root/Main/Scenario").add_child(enemy_instance)
