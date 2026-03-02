extends Control

signal map_interact(open)

@export var stars : Node3D
@export var telescope : Node3D
@export var con_logic: Node

@onready var paper1 = $Paper1
@onready var paper2 = $Paper2
@onready var graph = $Paper2/Clip/Graph

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
		targets[0]: $Paper1/Constellations/con1,
		targets[1]: $Paper1/Constellations/con2,
		targets[2]: $Paper1/Constellations/con3,
		targets[3]: $Paper1/Constellations/con4
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
var pressed1 = false
var pressed2 = false
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_book") and !pressed1:
		map_interact.emit(!visible)
		pressed1 = true
	else:
		pressed1 = false
	
	if !visible:
		return
	if Input.is_action_just_pressed("1"):
		paper1.visible = true
		paper2.visible = false
	if Input.is_action_just_pressed("2"):
		paper1.visible = false
		paper2.visible = true

var unlocked : Dictionary = {
	'venus': false, 'mars': false, 'jupiter': false, 'saturn': false
}

var planet_color : Dictionary = {
	'venus': Color("dba500"), 'mars': Color("eb394c"), 'jupiter': Color("ed912a"), 'saturn': Color("edc633")
}

@onready var planet_node : Dictionary = {
	'venus': graph.get_node("venus"), 
	'mars':  graph.get_node("mars"), 
	'jupiter':  graph.get_node("jupiter"), 
	'saturn':  graph.get_node("saturn")
}

func _on_telescope_chart(planet: Variant) -> void:
	if unlocked.has(planet):
		unlocked[planet] = true
		var node = planet_node[planet]
		node.modulate = planet_color[planet]
	
	
