extends Control

@export var stars : Node3D
@export var telescope : Node3D

var name_to_node : Dictionary

var con_to_unlocked : Dictionary = {
	'Ori': false,
	'Tau': false,
	'Aur': false,
	'Gem': false,
}

func _ready():
	visible = false
	name_to_node = {
	'Ori': $Paper/con1,
	'Tau': $Paper/con2,
	'Aur': $Paper/con3,
	'Gem': $Paper/con4
}

var current_finished : Array
	
func _physics_process(delta: float) -> void:
	for c in stars.constellations_finished:
		con_to_unlocked[c] = true
	unlock()
		
func color_change(node):
	node.modulate = Color(0.6, 0.4, 0.6)

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
