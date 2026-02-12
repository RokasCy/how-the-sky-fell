extends MeshInstance3D

@onready var parent = get_parent()

var const_lines_path = "res://star_data/hip_constellation_line.csv"

var constellation_type : Dictionary = {}
var connections = load_connections(const_lines_path)

var hip_dict = {}

func _ready():
	if mesh == null:
		mesh = ImmediateMesh.new()
		
	for star in parent.star_data:
		hip_dict[float(star["HIP"])] = star 
		
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	generate_constellations()
	mesh.surface_end()
	
func draw_line(star1, star2):
	#--position line--#
	var a = parent.star_to_position(star1)
	var b = parent.star_to_position(star2)
	
	var m : ImmediateMesh = mesh
	
	m.surface_add_vertex(a)
	m.surface_add_vertex(b)
	

func generate_constellations():
	for c in connections:
		var star1 = hip_dict.get(c[1], null)
		var star2 = hip_dict.get(c[2], null)
		
		if star1 != null and star2 != null:
			#print(c[0])
			draw_line(star1, star2)
			pass

func load_connections(path : String) -> Array:
	var results = []
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			var values = line.split(",")
			if len(values) <= 1:
				continue
			var connection = [values[0], float(values[1]), float(values[2])]
			
			constellation_type[float(values[1])] = values[0]
			constellation_type[float(values[2])] = values[0]
			results.append(connection)
	return results
		
