extends Node2D

export var canStart = true 
export var spawnTime = 1.0
export(String, "","Start_menu","Ambiental_city", "Combat", "In_Station", "Final_Boss") var soundtrack

var spawner
var obstacles

var enemyCount = 0

var sfx_path = "res://sound/sfx/explosions/"
var sfx_explosion_big = load(sfx_path + "explosion_big.wav")
var sfx_explosion_chunky = load(sfx_path + "explosion_chunky.wav")
var sfx_explosion_low_frequency = load(sfx_path + "explosion_low_frequency.ogg")

onready var sfx1 = get_node("sfx_player_1")
onready var sfx2 = get_node("sfx_player_2")

var event_ended = false
var bgm_player
var scenario
var tilemap
var event_path = "/root/"

onready var anim_player = get_node("AnimationPlayer")
onready var shades = get_node("shades")
onready var white_explosion = get_node("shades/white_explosion")
var player
onready var dialog_event = get_node("last_call")

var main_node = self
func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	
	while (main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	spawner = get_node("spawner/enemySpawner")
	var aux = get_tree().get_nodes_in_group("bgm_player")
	player = main_node.get_node("YSort/Player")
	if(aux.size() > 0):
		bgm_player = aux[0]
	aux = get_tree().get_nodes_in_group("scenario_collisions")
	if (aux.size() > 0):
		scenario = aux[0]
	tilemap = get_node("EventDetector")
	tilemap.visible = false
	obstacles = tilemap.get_used_cells_by_id(1)
	event_path += main_node.get_name() +"/Events/enter_boss_room"
	dialog_event.event_path = event_path
	shades.visible = true

func Start_Event():
	if canStart: 
		canStart = false
		if soundtrack != "":
			bgm_player.change_soundtrack(soundtrack)
		spawner.canSpawn = true
		spawner.spawnRate = spawnTime
			
		for i in range(obstacles.size()):
			scenario.set_cellv(obstacles[i],0)
			tilemap.set_cellv(obstacles[i],-1)
		player.z_index = 2
		while(!player.canMove):
			yield(get_tree().create_timer(0.01),"timeout")
		player.movementDirection = Vector2()
		player.canMove = false
		shades.get_node("black_shade").visible = true
		anim_player.play("fade_black_shade")
		shades.get_node("boss_room").visible = true
		
		var station_walls = main_node.get_node("YSort/station_walls")
		var station_objects = main_node.get_node("YSort/station_objects")
		station_walls.position = Vector2(0, 0)
		station_objects.position = Vector2(0, 0)
		
		
		yield(get_tree().create_timer(4),"timeout")
		player.canMove = true

func EndEvent():
	if event_ended == false:
		event_ended = true
		anim_player.play("screen_vibration")
		while(!player.canMove):
			yield(get_tree().create_timer(0.1),"timeout")
		player.canMove = false
		sfx2.stream = sfx_explosion_low_frequency
		sfx2.play()
		dialog_event.Start_Event()
		
func dialog_ended():
	white_explosion.set_global_position(get_tree().get_nodes_in_group("boss")[0].get_global_position()) 
	anim_player.play("explosion")
	sfx1.stream = sfx_explosion_big
	sfx1.play()
	sfx2.stream = sfx_explosion_chunky
	yield(get_tree().create_timer(3),"timeout")
	sfx2.play()
	main_node.end()
	
		
#	for i in range(obstacles.size()):
#		scenario.set_cellv(obstacles[i],-1)

