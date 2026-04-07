extends Node3D

@onready var telescope = $"../../../telescope"
@onready var telescope_ui = $"../../../Controls/UI"
@onready var mat = load("res://assets/material/sky.tres").duplicate()

var max_alpha = 0.4
func _physics_process(delta: float) -> void:
	if telescope == null:
		return
		
	var fov_val
	if telescope_ui.visible:
		fov_val = (telescope.camera.fov / 50 - 0.05)**4
	else:
		fov_val = max_alpha
	
	mat.albedo_color.a = clamp(fov_val, 0, max_alpha)
	$MeshInstance3D.set_surface_override_material(0, mat)
	
