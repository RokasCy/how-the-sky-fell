extends Node

@onready var stars = get_parent()
@onready var lines = $"../Constellations"
@onready var anomaly_mesh = $"../AnomalyMesh".mesh
@onready var milkyway = $"../milkyway"
@onready var ecliptic = $"../Ecliptic"

@onready var rumble = $"../AudioStreamPlayer3D"
@onready var env = $"../../../Environment"
@onready var music = $"../../../music"
@onready var telescope = $"../../../telescope"
@onready var game_logic = $"../../../Game logic"
var played = false

var belatrix_node
var belatrix
var belatrix_original

var staranomalies = []
var staranomalies_nodes = []
var star_speed = []
func _ready():
	await get_tree().create_timer(1.0).timeout
	belatrix_node = stars.get_node("25336_1")
	belatrix_original = lines.hip_dict[25336.0].duplicate()
	belatrix = lines.hip_dict[25336.0]
	for i in range(701):
		var child = stars.get_child(i)
		if str(child.name)[0] in "0123456789":	
			staranomalies.append(child.name)
			staranomalies_nodes.append(child)
			
			var dec_speed = randf_range(-75.0, 75.0)
			var ra_speed = randf_range(-5.0, 5.0)
			star_speed.append([dec_speed, ra_speed])

			

func star_movement(delta, count):
	for i in range(count):
		var hip = float(staranomalies[i].substr(0, staranomalies[i].length() - 2))
		if lines.constellation_type[hip] in ["Aur", "Tau", "Ori", "Gem"]:
			continue
		
		var anomaly = lines.hip_dict[hip]
		
		anomaly["DEC_min"] += delta*star_speed[i][0]
		anomaly["RA_min"] += delta*star_speed[i][1]
		
		if is_instance_valid(staranomalies_nodes[i]):
			staranomalies_nodes[i].position = stars.star_to_position(anomaly)

func star_escape(delta):
	#milkyway.max_alpha -= delta/10
	#milkyway.max_alpha = max(milkyway.max_alpha, 0)
	for i in range(staranomalies.size()):
		var hip = float(staranomalies[i].substr(0, staranomalies[i].length() - 2))
		
		var anomaly = lines.hip_dict[hip]
		
		var declination = abs(anomaly["DEC_deg"]) + abs(anomaly["DEC_min"] / 60)
		
		if declination < 90:
			anomaly["DEC_min"] += delta*300

			
		
		if is_instance_valid(staranomalies_nodes[i]):
			staranomalies_nodes[i].position = stars.star_to_position(anomaly)
			
			if declination > 89:
				staranomalies_nodes[i].queue_free()
	
	#belatrix["DEC_deg"] += delta/60 * 200
	#belatrix_node.position = stars.star_to_position(belatrix)
	#print(belatrix)
var elapsed = 0.0
var t = 0.0
var ending = false
func _physics_process(delta: float) -> void:
	if 4 in Gamestate.anomalies:
		t += delta
		
		star_escape(delta)
		lines.constellations_done.mesh.clear_surfaces()
		anomaly_mesh.clear_surfaces()
		finish_constellation("Ori")
		finish_constellation("Tau")
		finish_constellation("Aur")
		finish_constellation("Gem")
		
		if !rumble.playing:
			rumble.play()
		
		if t > 18.0:
			anomaly_mesh.clear_surfaces()
			if is_instance_valid(telescope):
				telescope.queue_free()
				game_logic.player_can_move = true
			env.position.y = move_toward(env.position.y, -1000.0, 10 * delta)
			milkyway.visible = false
			ecliptic.visible = false
			
		if t > 25.0:
			var bus = AudioServer.get_bus_index("All sounds")
			var db = AudioServer.get_bus_volume_db(bus)
			AudioServer.set_bus_volume_db(bus, max(db-0.1, -80))
		
		if t > 30.0 and !music.playing:
			music.play()
		
		if t > 57.8:
			get_tree().change_scene_to_file("res://menu/end_card.tscn")
				
	elif 2 in Gamestate.anomalies:
		if elapsed < 6.0:
			belatrix["RA_min"] -= delta*1.0
			belatrix["DEC_min"] += delta*90
			
			elapsed+=delta
		else:
			belatrix["RA_min"] = lerp(belatrix["RA_min"], belatrix_original["RA_min"], delta*15)
			belatrix["DEC_min"] = lerp(belatrix["DEC_min"], belatrix_original["DEC_min"], delta*15)
		
		belatrix_node.position = stars.star_to_position(belatrix)
		anomaly_mesh.clear_surfaces()
		finish_constellation("Ori")
	
		star_movement(delta, 10*Gamestate.constellations_unlocked.size()+8)
	
	
func finish_constellation(con):
	var con_lines = lines.constellation_lines[con]
	
	var m : ImmediateMesh = anomaly_mesh
	m.surface_begin(Mesh.PRIMITIVE_LINES)
	for couple in con_lines:
		var a = stars.star_to_position(lines.hip_dict[couple[0]])
		var b = stars.star_to_position(lines.hip_dict[couple[1]])
		m.surface_add_vertex(a)
		m.surface_add_vertex(b)
	m.surface_end()
