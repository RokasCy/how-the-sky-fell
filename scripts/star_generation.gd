extends MultiMeshInstance3D

var star_count := multimesh.instance_count
@export var star_distance := 400

func _ready() -> void:
	for i in range(star_count):
		var pos = random_point_on_sphere()
		var scale = Vector3.ONE * randf_range(0.05, 0.2)
		var transform = Transform3D(Basis(), pos)
		transform.basis.scaled(scale)
		
		multimesh.set_instance_transform(i, transform)
	
func random_point_on_sphere():
	var theta = randf() * TAU
	var phi = randf() * TAU
	
	var x = star_distance * sin(theta) * cos(phi)
	var y = star_distance * cos(theta)
	var z = star_distance * sin(theta) * sin(phi)
	
	return Vector3(x, y, z)
