extends Node

@onready var stars = get_parent()
@onready var lines = $"../Constellations"
@onready var anomaly_mesh = $"../AnomalyMesh".mesh
var played = false

var belatrix_node
var belatrix
var belatrix_original


func _ready():
	await get_tree().create_timer(1.0).timeout
	belatrix_node = stars.get_node("25336_0")
	belatrix_original = lines.hip_dict[25336.0].duplicate()
	belatrix = lines.hip_dict[25336.0]
	
	#Gamestate.anomalies.append(2)

var elapsed = 0.0
func _physics_process(delta: float) -> void:
	if 2 in Gamestate.anomalies:
		if elapsed < 8.0:
			#belatrix_node.position = belatrix_node.position.lerp(Vector3(20, 20, 20), delta / 10)
			belatrix["RA_min"] -= delta*1
			belatrix["DEC_min"] += delta*50
			elapsed+=delta
		else:
			belatrix["RA_min"] = lerp(belatrix["RA_min"], belatrix_original["RA_min"], delta*15)
			belatrix["DEC_min"] = lerp(belatrix["DEC_min"], belatrix_original["DEC_min"], delta*15)
			
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
