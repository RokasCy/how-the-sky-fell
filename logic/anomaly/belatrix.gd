extends Node

@onready var stars = get_parent()
@onready var lines = $"../Constellations"
@onready var completed_lines = $"../Finished"
var played = false

var belatrix_node
var belatrix
var meissa
var mintaka

func _ready():
	await get_tree().create_timer(1.0).timeout
	belatrix_node = stars.get_node("25336_0")
	belatrix = lines.hip_dict[25336.0]
	meissa = lines.hip_dict[26207.0]
	mintaka = lines.hip_dict[25930.0]
	
	
	Gamestate.anomalies.append(2)
func _physics_process(delta: float) -> void:
	if 2 in Gamestate.anomalies:
		#belatrix_node.position = belatrix_node.position.lerp(Vector3(20, 20, 20), delta / 10)
		belatrix["RA_min"] -= delta
		belatrix["DEC_min"] += delta*15
		lines.mesh.clear_surfaces()
		lines.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		lines.draw_line(meissa, belatrix)
		lines.draw_line(mintaka, belatrix)
		lines.mesh.surface_end()
