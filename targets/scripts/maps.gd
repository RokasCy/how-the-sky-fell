extends Control

signal map_interact(open)

@export var stars : Node3D
@export var telescope : Node3D
@export var con_logic: Node

@onready var paper0 = $Paper0
@onready var paper1 = $Paper1
@onready var discovery_text = $Paper1/RichTextLabel
@onready var paper2 = $Paper2
@onready var graph = $Paper2/Clip/Graph

@onready var planet_chime = $planet_chime

@export var papersfx: AudioStreamPlayer3D
@onready var animations = $"../../Animations"


#--constellation textures--#

# name : [unfinished, finished] textures
var textures : Dictionary = {
	'Ori': ["uid://d0vcvnwiobyk6", "uid://dmnmqcbpdr6qm"],
	'Tau': ["uid://ctomfb0egscyn", "uid://cfqr4oddic1fj"],
	'Aur': ["uid://behsstyl417vy", "uid://die0bsok7r3mk"],
	'Gem': ["uid://do448vpp5if6d", "uid://dh4c2jykyaxmg"],
	
	'Hya': ["uid://djyeudgw4ja87", "uid://n6lnkamkiumn"],
	'Cnc': ["uid://b1xv626065ogd", "uid://bht7tgho08ctc"],
	'Leo': ["uid://ccw11biydsx7i", "uid://bbisibemuax80"],
	'Vir': ["uid://besithcy4yy6x", "uid://lsak5c1av21o"],
	
	"Boo": ["uid://bjc47lgcui1ak", "uid://baqkxhbralljy"],
	"Dra": ["uid://d2658c1jfthke", "uid://drvhvfwxf4cg3"],
	"UMa": ["uid://cbf30psifxpg6", "uid://tljl1ulmpkmr"],
	"UMi": ["uid://chsvhxdhpd2mc", "uid://cij4s760a0xao"]
}

var const_to_namepos : Dictionary = {
	"Ori": Vector2(210, 280),
	"Tau": Vector2(270, 150),
	"Aur": Vector2(240, 60),
	"Gem": Vector2(20, 170),
	
	"Hya": Vector2(136, 250),
	"Cnc": Vector2(325, 70),
	"Leo": Vector2(200, 115),
	"Vir": Vector2(30, 120),
	
	"Boo": Vector2(252, 247),
	"Dra": Vector2(86, 268),
	"UMa": Vector2(209, 160),
	"UMi": Vector2(84, 159)
}


var name_to_node : Dictionary
var con_to_unlocked : Dictionary

var orig_rotation_rate : float

@onready var targets = con_logic.night_targets[con_logic.main.Night]
func _ready():
	visible = false
	
	
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
		
		name_to_node[name].get_node("name").position = const_to_namepos[name]
		
	orig_rotation_rate = stars.rotation_rate
	
		
var morning_trans : bool = false
func _physics_process(_delta: float) -> void:
	
	for c in Gamestate.constellations_unlocked:
		if con_to_unlocked.has(c) and con_to_unlocked[c] == false:
			con_to_unlocked[c] = true
			update_completion(name_to_node[c], c)
		
	check_target_completion()
	#if stars.sun_height > 0.2 and !morning_trans:
		#morning_trans = true
		
		#stars.rotation_rate = orig_rotation_rate
		#if switched:
			#await animations.animation_finished
			
		#animations.play("night_transition")

	
func update_completion(node, name):
	node.texture = load(textures[name][1])
	node.modulate = Color(0.0, 0.0, 0.0)
	
	node.get_node("name").text = name
	if !animations.is_playing():
		animations.play("constellation_discovered")

var switched = false
func check_target_completion():
	var all_found = true
	for k in con_to_unlocked:
		if !con_to_unlocked[k]:
			all_found = false
			break
			
	for k in planet_to_unlocked:
		if !planet_to_unlocked[k]:
			all_found = false
			break
			
	#all_found=true
	if all_found and !switched:
		animations.play("all_targets_found")
		await animations.animation_finished
		Gamestate.anomalies.append(4)
		switched = true
		
		
	
#--toggling map view--#
var pressed1 = false
var pressed2 = false
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_book") and !pressed1:
		map_interact.emit(!visible)
		if visible:
			papersfx.play()
			
		pressed1 = true
	else:
		pressed1 = false
	
	if !visible:
		return
	if Input.is_action_just_pressed("1"):
		paper0.visible = true
		paper1.visible = false
		paper2.visible = false
	if Input.is_action_just_pressed("2"):
		paper0.visible = false
		paper1.visible = true
		paper2.visible = false
	if Input.is_action_just_pressed("3"):
		paper0.visible = false
		paper1.visible = false
		paper2.visible = true
		
		

#--planet charting--#

var planet_to_unlocked : Dictionary = {
	'venus': true, 'mars': true, 'jupiter': false, 'saturn': true
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
	if planet_to_unlocked.has(planet):
		planet_to_unlocked[planet] = true
		var node = planet_node[planet]
		
		node.modulate = planet_color[planet]
		planet_chime.play()
		animations.play("planet_charted")
		
		
	
	
