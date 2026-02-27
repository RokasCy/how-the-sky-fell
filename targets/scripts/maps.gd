extends Control

@export var stars : Node3D
@export var telescope : Node3D

var name_to_node : Dictionary

var con_to_unlocked : Dictionary = {
	'Ori': false,
	'Tau': false,
	'Lep': false,
	'Aur': false,
}

func _ready():
	visible = false
	name_to_node = {
	'Ori': $Constellations/con1,
	'Tau': $Constellations/con2,
	'Lep': $Constellations/con3,
	'Aur': $Constellations/con4
}

var current_finished : Array
	
func _physics_process(delta: float) -> void:
	for c in stars.constellations_finished:
		con_to_unlocked[c] = true
	unlock()
		
func color_change(node):
	node.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0))

func unlock():
	for k in con_to_unlocked:
		if con_to_unlocked[k]:
			color_change(name_to_node[k])


#--toggling map view--#
var pressed = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_book") and !pressed and !telescope.zoomed_in:
		visible = !visible
		pressed = true
	else:
		pressed = false
