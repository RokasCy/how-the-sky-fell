extends Node3D

var star_path = "res://stars/star_data/hip_constellation_line_star.csv"

@onready var constellation_type = $Constellations.constellation_type
@onready var hip_dict = $Constellations.hip_dict

var headers = ["HIP","RA_hour","RA_min","RA_sec","DEC_deg","DEC_min","DEC_sec","Magnitude", "B-V"]
var star_data = load_csv(star_path)

@export_group("Sky")
@export_range(-90.0, 90.0) var longitude := 90.0
@export_range(0.0, 1.0) var rotation_rate := 0.0

@export_group("Star properties")
@export var distance := 100
@export var scale_factor := 11
@export var flux_factor := 8

@onready var constellations_finished = $Constellations.constellations_finished

func _ready() -> void:
	#setting location
	self.rotation.x = deg_to_rad(90 - longitude)
	generate_stars()

#----debug utility----#
func _physics_process(delta: float) -> void:
	
	#rotate around local basis.y axis
	rotate(global_transform.basis.y, -deg_to_rad(rotation_rate * delta))
	
func remove_stars():
	for child in self.get_children():
		child.queue_free()	
		
func generate_stars():
	for star in star_data:
		if len(star) <= 1:
			continue
		
		var id = star["HIP"]
		var starposition = star_to_position(star)
		var mag = star["Magnitude"]
		var b_v = star["B-V"]
		create_star(id, starposition, mag, b_v)

	
	
func star_to_position(star):
	var ra_hour = float(star["RA_hour"]) + float(star["RA_min"]) / 60 + float(star["RA_sec"]) / 3600
	var dec_deg = abs(float(star["DEC_deg"])) + abs(float(star["DEC_min"])) / 60 + abs(float(star["DEC_sec"])) / 3600
		
	if int(star["DEC_deg"]) < 0:
		dec_deg = -dec_deg
		
	var ra_rad = deg_to_rad(ra_hour * 15) 
	var dec_rad = deg_to_rad(dec_deg) 
	
	var x = distance * cos(dec_rad) * cos(-ra_rad)
	var y = distance * sin(dec_rad)
	var z = distance * cos(dec_rad) * sin(-ra_rad)
	
	return Vector3(x, y, z)

func create_star(id, starposition, mag, b_v, mat=null):
	if mag > 20:
		return 
	var star := MeshInstance3D.new()
	var mesh = QuadMesh.new()
	var material : StandardMaterial3D = load("res://assets/material/const_star.tres").duplicate()
	
	#--brightness--#
	star.scale = star_scale(mag)
	material.emission_energy_multiplier = star_flux(mag)
	
	#--color--#
	if typeof(b_v) == TYPE_FLOAT:
		material.emission = bv_to_rgb(b_v)
	else:
		material.emission  = Color(1.0, 1.0, 1.0)
	
	if mat==null:
		mesh.material = material
	else:
		mesh.material = mat
		
	star.mesh = mesh
	star.position = starposition
	
	star.name = str(id)
	self.add_child(star)
	
func star_scale(mag):
	var F0 = 3.6e-8  # flux of magnitude 0 star in V-band
	var F = F0 * 10**(-0.4 * mag)
	
	var starscale = 2**scale_factor * (F**0.2)
	return Vector3(starscale, starscale, starscale)

func star_flux(mag):
	var F0 = 3.6e-8  # flux of magnitude 0 star in V-band
	var F = F0 * 10**(-0.4 * mag)
	var f = 2**flux_factor * F
	
	#upper limit
	if f > 6:
		f = 6
	return f

func bv_to_rgb(bv):
	var r = 0.0
	var g = 0.0
	var b = 0.0
	var t = 0.0 #helper to map bv range from 0 to 1

	bv = clamp(bv, -0.4, 2.0)

	if bv < 0.0:  # very hot blue stars
		t = (bv + 0.4) / 0.4
		r = 0.55 + 0.11*t + 0.1*t*t
		g = 0.7 + 0.07*t + 0.1*t*t
		b = 1.0
	elif bv < 0.4:  # white-yellow stars
		t = bv / 0.4
		r = 0.83 + 0.17*t
		g = 0.87 + 0.11*t
		b = 1.0 - 0.5*t*t
	elif bv < 1.5:  # yellow-orange stars
		t = (bv - 0.4) / 1.1
		r = 1.0
		g = 0.98 - 0.16*t
		b = 0.8 - 0.5*t*t
	else:  # red stars
		t = (bv - 1.5) / 0.5
		r = 1.0
		g = 0.75 - 0.5*t*t
		b = 0.6 - 0.6*t*t

	r = clamp(r, 0, 1)
	g = clamp(g, 0, 1)
	b = clamp(b, 0, 1)
	
	return Color(r, g, b)

func load_csv(path: String) -> Array:
	var result = []
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			var values = line.split(",")
			
			var dict_values = {}
			for i in range(len(headers)):
				if i+1 > len(values):
					continue
				
				var value = values[i]
				if i == 8:
					value = values[12]
				if value.is_valid_float():
					dict_values[headers[i]] = float(value)
				else:
					dict_values[headers[i]] = value
					
			result.append(dict_values)
		file.close()
	else:
		print("Failed to open CSV file: ", path)
		
	return result
