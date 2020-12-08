extends VBoxContainer

onready var color_rect = get_node("../ColorRect")
onready var bgm_scroller = get_node("Bgm/Control/bgm_ScrollBar")
onready var sfx_scroller = get_node("Sfx/Control/sfx_HScrollBar")
var main_node = self


var sfx_path = "res://sound/sfx/ui/"
var sfx_hover = load(sfx_path + "mouse_hover.wav")
var sfx_select = load(sfx_path + "ui_select.wav")
onready var sfx = get_node("sfx_player")


func _ready():
	while(main_node.get_parent() != get_tree().get_root()):
		main_node = main_node.get_parent()
	bgm_scroller.value = main_node.bgm_volume*100
	sfx_scroller.value = main_node.sfx_volume*100

func _on_Volume_button_pressed():
	sfx.stream = sfx_select
	sfx.play()
	color_rect.visible = !self.visible
	self.visible = !self.visible

func _on_bgm_ScrollBar_value_changed(value):
	main_node.change_bgm_volume(value/100) 


func _on_sfx_HScrollBar_value_changed(value):
	main_node.change_sfx_volume(value/100)


func _on_Volume_button_mouse_entered():
	sfx.stream = sfx_hover
	sfx.play()
