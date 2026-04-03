extends Node

@onready var stars = get_parent()
@onready var lines = $"../Constellations"
@onready var anomaly_mesh = $"../AnomalyMesh".mesh
var played = false

var belatrix_node
var belatrix
var belatrix_original

var staranomalies = [] #["6686_0", "36188_0", "72607_0", "44127_0"]
var staranomalies_nodes = []
func _ready():
	await get_tree().create_timer(1.0).timeout
	belatrix_node = stars.get_node("25336_0")
	belatrix_original = lines.hip_dict[25336.0].duplicate()
	belatrix = lines.hip_dict[25336.0]
	for i in range(400):
		var child = stars.get_child(i)
		if str(child.name)[0] in "0123456789":	
			staranomalies.append(child.name)
			staranomalies_nodes.append(child)

func star_movement(delta):
	for i in range(staranomalies.size()):
		var hip = float(staranomalies[i].substr(0, staranomalies[i].length() - 2))
		var anomaly = lines.hip_dict[hip]
		
		anomaly["DEC_min"] += delta*200
		
		staranomalies_nodes[i].position = stars.star_to_position(anomaly)
var elapsed = 0.0
func _physics_process(delta: float) -> void:
	if 2 in Gamestate.anomalies:
		if elapsed < 8.0:
			#belatrix_node.position = belatrix_node.position.lerp(Vector3(20, 20, 20), delta / 10)
			belatrix["RA_min"] -= delta*1.0
			belatrix["DEC_min"] += delta*70
			
			elapsed+=delta
		else:
			belatrix["RA_min"] = lerp(belatrix["RA_min"], belatrix_original["RA_min"], delta*15)
			belatrix["DEC_min"] = lerp(belatrix["DEC_min"], belatrix_original["DEC_min"], delta*15)
			
		#star_movement(delta)
			
		belatrix_node.position = stars.star_to_position(belatrix)
		anomaly_mesh.clear_surfaces()
		finish_constellation("Ori")
	
		

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
