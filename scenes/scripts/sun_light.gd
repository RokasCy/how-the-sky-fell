extends DirectionalLight3D

#beautiful
@onready var world_env = $"../../../../../WorldEnvironment"
@onready var stars = $"../../.."
@onready var parent = get_parent()

#distance variable inside force_distance
@onready var distance = parent.distance

var shader : ShaderMaterial
func _ready():
	if world_env:
		shader = world_env.environment.sky.sky_material
		
func _physics_process(_delta: float) -> void:
	look_at(Vector3(0, 0, 0), Vector3.UP)
	
	var sun_height = (global_position.y / distance) if global_position.y > 0 else 0
	light_energy = sun_height**0.8 * 10 
	
	shader.set_shader_parameter("SunHeight", sun_height)
	stars.sun_height = sun_height
	
