extends Node3D

@onready var telescope = $"../../../telescope"
@onready var mat = load("res://assets/material/sky.tres").duplicate()

func _physics_process(delta: float) -> void:
	if telescope.camera == null:
		return
		
	var fov_val = (telescope.camera.fov / 50 - 0.05)**4
	
	mat.albedo_color.a = clamp(fov_val, 0, 0.3)
	$MeshInstance3D.set_surface_override_material(0, mat)
	
