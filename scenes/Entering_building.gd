extends Node2D

var canStart = true
var player
var bgm_player
var spawners = []
var enemyCount = 0

var lines = []
var letters_duration = []

var obstacle = preload("res://prefabs/SceneObjects/obstacles/obstacle.tscn")
var obstacle_instances=[]

var animation_player
onready var labels = get_node("Dialog_lines").get_children()
var node_path
var main_node = self
var dialog
var entrance
var in_node
var scenario
onready var tilemap = get_node("EventDetector")
var door
func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	player = main_node.get_node("YSort/Player")
	bgm_player = main_node.get_node("BgmStreamPlayer")
	dialog = main_node.get_node("ScreenCanvas/Dialog")
	animation_player  = main_node.get_node("ScreenCanvas/Fading/FadingPlayer")
	node_path = "/root/"+ main_node.get_name()+"/"+ get_parent().get_name()+"/"+ get_name()
	entrance = get_node("target").get_global_position()
	in_node = get_node("in").get_global_position()
	spawners = get_node("spawners").get_children()
	scenario = main_node.get_node("YSort")
	door = tilemap.get_used_cells_by_id(1)
	for i in range(door.size()):
		obstacle_instances.push_back(obstacle.instance())
		obstacle_instances[i].call_deferred("set","position",tilemap.map_to_world(door[i])) 
		scenario.add_child(obstacle_instances[i])
	
	
func Start_Event(): 
	if canStart == true:
		canStart = false
		for i in range(labels.size()):
			lines.push_back(labels[i].text)
			letters_duration.push_back(labels[i].time_between_letters)
		dialog.Begin_dialog(lines,letters_duration,node_path)
	
		player.canMove = false
		player.movementDirection = Vector2()
		
		for i in range(spawners.size()):
			spawners[i].canSpawn = true
			

var wave_enemies = []
func dialog_ended():
	player.canMove = false
	var player_position = player.get_global_position()
	var move = Vector2(entrance.x - player_position.x , (entrance.y - player_position.y)*2)
	player.movementDirection = move
	wave_enemies = get_tree().get_nodes_in_group("wave_enemy")
	for _i in range(wave_enemies.size()):
		wave_enemies[_i].isPaused = false
	
	for _i in range(obstacle_instances.size()):
		var aux = obstacle_instances.pop_front()
		aux.queue_free()
		yield(get_tree().create_timer(0.01),"timeout")
	

var event_ended =false
func EndEvent():
	if !event_ended:
		event_ended = true
		main_node.soundtrack = "In_Station"
		
		for i in range(door.size()):
			obstacle_instances.push_back(obstacle.instance())
			obstacle_instances[i].position = tilemap.map_to_world(door[i])
			scenario.add_child(obstacle_instances[i])
			yield(get_tree().create_timer(0.01),"timeout")
		main_node.refresh_states()

var canEnter = true
func _on_entrance_body_entered(body):
	if body.is_in_group("player") and canEnter :
		var player_position = player.get_global_position()
		var move = Vector2(in_node.x - player_position.x , (in_node.y - player_position.y)*2)
		player.movementDirection = move

func _on_in_body_entered(body):
	if body.is_in_group("player") and canEnter:
		canEnter = false
		main_node.save_player_position()
		player.canMove = true
		animation_player.play("EnterBuilding")
		for i in range(wave_enemies.size()):
			wave_enemies[i].queue_free()
		wave_enemies = []
		EndEvent()
