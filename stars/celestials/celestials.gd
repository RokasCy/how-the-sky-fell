extends Node

@export var distance : int = 1200
@export var logic : Node

@onready var parent = get_parent()

var headers = ["name", "rad", "dec", "size"]
var data = load_csv( "uid://da8deas015hy")

var cestial_texture = {
	"orion nebula": load("uid://bfa8yh7mpaig6"),
	"pleiades": load("uid://dhjdq3t8to0il")}

var template_object = load("res://stars/celestials/object.tscn")

func _ready():
	spawn_all()

func spawn_all():
	for obj in data:
		var instance = template_object.instantiate()
		instance.position = coord_to_position(
			float(obj["rad"]),
			float(obj["dec"])
		)
		
		instance.material_override = instance.material_override.duplicate()
		instance.material_override.albedo_texture = cestial_texture[obj["name"]]
		var theta = deg_to_rad(float(obj["size"]))/2
		var size = tan(theta) * 2 * distance
		instance.mesh.size = Vector2(size, size)
		print(size)
		parent.call_deferred("add_child", instance)
	
func coord_to_position(ra_deg, dec_deg):
	var ra_rad = deg_to_rad(ra_deg)
	var dec_rad = deg_to_rad(dec_deg)
	
	var x = distance * cos(dec_rad) * cos(-ra_rad)
	var y = distance * sin(dec_rad)
	var z = distance * cos(dec_rad) * sin(-ra_rad)
	
	return Vector3(x, y, z)
func load_csv(path):
	var result = []
	var file = FileAccess.open(path, FileAccess.READ)
	
	while !file.eof_reached():
		var line = file.get_line()
		var values = line.split(",")
		
		if len(values) <= 1:
			continue
		
		var dict = {}
		for i in range(len(headers)):
			dict[headers[i]] = values[i]
		
		result.append(dict)
	
	return result
		
