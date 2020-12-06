extends Control

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var weapon = player.get_node("Weapon")

onready var health_bar = get_node("HealthBar")
onready var heal_charges = get_node("HealCharges")
onready var abilities = get_node("ReferenceRect/Node2D").get_children()
onready var animation_player = get_node("HealCharges/Sprite/AnimationPlayer")
func _ready():
	yield(get_tree().create_timer(0.03),"timeout")
	for i in range(abilities.size()):
		abilities[i].modulate.a = 0.5
		abilities[i].visible = false
		if i < weapon.weapon_level:
			abilities[i].visible = true

func _process(_delta):
	health_bar.value =  player.health
	heal_charges.value = player.healCharges
	
	if player.health < 100:
		heal_charges.get_node("Sprite").visible = true
	if player.health < 50:
		animation_player.play("needs_healing")
	else:
		animation_player.stop(true)
	if player.canDash:
		if Input.is_action_just_pressed("dash"):
			abilities[4].visible = false
				

func update_abilities(shootMode):
	shootMode -= 1
	for i in range(abilities.size()-1):
		if i != shootMode:
			abilities[i].modulate.a = 0.5
		else:
			abilities[i].modulate.a = 1

func show_next_ability():
	for i in range(abilities.size()-1):
		if !abilities[i].visible:
			abilities[i].visible = true
			break

func show_dash_ability():
	get_node("ReferenceRect/Node2D/AnimatedSprite").visible = true
