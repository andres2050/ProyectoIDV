extends VBoxContainer

onready var color_rect = get_node("../ColorRect")

var main_node = self

func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()

func _on_Volume_button_pressed():
	color_rect.visible = !self.visible
	self.visible = !self.visible

func _on_bgm_ScrollBar_value_changed(value):
	main_node.bgm_volume = value/100


func _on_sfx_HScrollBar_value_changed(value):
	main_node.sfx_volume = value/100
