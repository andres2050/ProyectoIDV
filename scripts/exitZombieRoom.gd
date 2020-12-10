extends Node2D

var canStart = true

var room_events = []
var spawners = []
onready var tilemap = get_node("EventDetector")
var obstacles
var scenario

func _ready():
	var events = get_parent()
	room_events.push_back(events.get_node("zombieRoom"))
	room_events.push_back(events.get_node("zombieRoom2"))
	room_events.push_back(events.get_node("zombieRoom3"))
	room_events.push_back(events.get_node("zombieRoom4"))
	
	for i in range(room_events.size()):
		spawners.push_back(room_events[i].get_node("Spawners").get_children())
		
	obstacles = tilemap.get_used_cells_by_id(1)
	yield(get_tree().create_timer(0.01),"timeout")
	var aux = get_tree().get_nodes_in_group("scenario_collisions")
	if (aux.size() > 0):
		scenario = aux[0]


var enemies
func Start_Event():
	if canStart:
		canStart = false
		for i in range(spawners.size()):
			for t in range(spawners[i].size()):
				spawners[i][t].stop_spawning()
		enemies = get_tree().get_nodes_in_group("zombie")
		for i in range(enemies.size()):
			enemies[i].die_quiet()
			
		for i in range(obstacles.size()):
			scenario.set_cellv(obstacles[i],0)
			tilemap.set_cellv(obstacles[i],-1)
		EndEvent()

func EndEvent():
	var main_node = self
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	main_node.refresh_states()
	main_node.save_player_position()
