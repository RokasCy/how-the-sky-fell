extends Node3D

@onready var telescope = $"../../Telescope".telescope
@onready var mat = load("res://assets/material/sky.tres").duplicate()
func _ready():
	# Make sure the material supports transparency
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# Assign it once as an override
	$MeshInstance3D.set_surface_override_material(0, mat)
	
func _physics_process(delta: float) -> void:
	var fov = (telescope.fov / 50 - 0.05)**2
	mat.albedo_color.a = clamp(fov, 0, 0.3)
	print(fov)
	$MeshInstance3D.set_surface_override_material(0, mat)
	print(mat.albedo_color.a)
