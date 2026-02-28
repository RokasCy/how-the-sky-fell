extends Control

@export var stars : Node3D
@export var telescope : Node3D
@export var con_logic: Node

#--constellation textures--#

# name : [unfinished, finished] textures
var textures : Dictionary = {
	'Ori': ["uid://d0vcvnwiobyk6", "uid://dmnmqcbpdr6qm"],
	'Tau': ["uid://ctomfb0egscyn", "uid://cfqr4oddic1fj"],
	'Aur': ["uid://behsstyl417vy", "uid://die0bsok7r3mk"],
	'Gem': ["uid://do448vpp5if6d", "uid://dh4c2jykyaxmg"]
}

var name_to_node : Dictionary
var con_to_unlocked : Dictionary

func _ready():
	visible = false
	var targets = con_logic.night_targets[con_logic.main.Night]
	
	name_to_node = {
		targets[0]: $Paper/con1,
		targets[1]: $Paper/con2,
		targets[2]: $Paper/con3,
		targets[3]: $Paper/con4
	}
	
	con_to_unlocked = {
		targets[0]: false,
		targets[1]: false,
		targets[2]: false,
		targets[3]: false
	}
	
	for i in range(len(targets)):
		var name = targets[i]
		name_to_node[name].texture = load(textures[name][0])
		name_to_node[name].modulate = Color(0.3, 0.3, 0.3, 0.8)
		

func _physics_process(_delta: float) -> void:
	for c in stars.constellations_finished:
		con_to_unlocked[c] = true
	unlock()
		
func update_completion(node, name):
	node.texture = load(textures[name][1])
	node.modulate = Color(0.0, 0.0, 0.0)
	
	node.get_node("name").text = name

func unlock():
	for k in con_to_unlocked:
		if con_to_unlocked[k]:
			update_completion(name_to_node[k], k)


#--toggling map view--#
var pressed = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_book") and !pressed and !telescope.zoomed_in:
		visible = !visible
		pressed = true
	else:
		pressed = false
