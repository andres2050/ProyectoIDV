extends StaticBody2D

var closed = true
var scenario
export(Array,String, "","HealingPickup", "WeaponPickup", "dashpickup")var pickups = []
var drops = []
func _ready():
	yield(get_tree().create_timer(0.01),"timeout")
	scenario = get_tree().get_nodes_in_group("Scenario")[0]
	var pickups_path = "res://prefabs/SceneObjects/Pickup_items/"
	for i in range(pickups.size()):
		drops.push_back(load(pickups_path + pickups[i] +".tscn").instance())
		drops[i].fall_x = (i+1) * (float(2) / (pickups.size() + 1))  -1
		drops[i].position = get_global_position()

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("bullet") and closed:
		closed = false
		open_chest()
		
func open_chest():
	for i in range(drops.size()):
		scenario.call_deferred("add_child",drops[i])
