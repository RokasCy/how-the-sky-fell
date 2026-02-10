extends Node3D

var star_path = "res://star_data/hip_constellation_line_star.csv"
var const_lines = "res://star_data/hip_constellation_line.csv"

@export var distance := 100

func _ready() -> void:
	var csv_data = load_csv(star_path)
	
	generate_constellations()

func generate_constellations():
	var star_data = load_csv(star_path)
	for star in star_data:
		if len(star) <= 1:
			continue
		var ra_hour = float(star[1]) + float(star[2]) / 60 + float(star[3]) / 3600
		var dec_deg = abs(float(star[4])) + abs(float(star[5])) / 60 + abs(float(star[6])) / 3600
		if int(star[4]) < 0:
			dec_deg = -dec_deg
		
		var position = coord_to_position(ra_hour, dec_deg)
		#orion
		var orion_hip_numbers = [
			27989,  # Betelgeuse (α Orionis)
			24436,  # Rigel (β Orionis)
			25336,  # Bellatrix (γ Orionis)
			27366,  # Saiph (κ Orionis)
			26727,  # Alnitak (ζ Orionis)
			26311,  # Alnilam (ε Orionis)
			25930   # Mintaka (δ Orionis)
		]
		
		#if int(star[0]) in orion_hip_numbers:
			#print(ra_hour, " ", dec_deg)
		create_star(position)
	
	

func coord_to_position(ra_hour, dec_deg):
	var ra_rad = deg_to_rad(ra_hour * 15) 
	var dec_rad = deg_to_rad(dec_deg) 
	
	var x = distance * cos(dec_rad) * cos(-ra_rad)
	var y = distance * sin(dec_rad)
	var z = distance * cos(dec_rad) * sin(-ra_rad)
	
	return Vector3(x, y, z)
	
func create_star(position):
	var star := MeshInstance3D.new()
	var mesh = SphereMesh.new()
	mesh.material = StandardMaterial3D.new()
	mesh.material.albedo_color = Color(1.0, 1.0, 1.0)
	mesh.material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	star.mesh = mesh
	star.position = position
	self.add_child(star)

func load_csv(path: String) -> Array:
	var result = []
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			var values = line.split(",")  # Split line by commas
			result.append(values)
		file.close()
	else:
		print("Failed to open CSV file: ", path)
		
	return result
