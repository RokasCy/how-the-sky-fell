extends MeshInstance3D

@onready var message = $"../anomaly1"
@onready var park = $"../anomaly2"
@onready var wind = $"../anomaly3"

@onready var bush1 = $"../anomaly4"
@onready var bush2 = $"../anomaly5"
@onready var environment = $"../../../../../WorldEnvironment".environment
@onready var globe = $"../../.."
@onready var milkyway = $"../../../milkyway"
@onready var camera = $"../../../../Main_camera"
@onready var sun = $"../../Sun"
@onready var saturn = get_parent()
#var ring_mat = load("res://scenes/planets/saturn.tscn::StandardMaterial3D_fpsqh")
#Gamestate
var bush1pos = Vector3(12.46469, 1.017148, 5.294871)
var bush2pos = Vector3(-15.22458, 0.975708, -5.983067)
var original_globe_rotation 
var original_milkyway_alpha
func _ready():
	sun.visible = false
	await get_tree().create_timer(1.0).timeout
	original_milkyway_alpha = milkyway.max_alpha

func fog_fade():
	bush1.global_position = bush1pos
	bush2.global_position = bush2pos
	
	var duration = 10.0
	var t=0.0
	
	var start_fog_density = 0.0
	var target_fog_density = 0.1
	
	#wprint(bush2.position)
	while t < duration:
		t += get_process_delta_time()
		#print(environment.volumetric_fog_density)
		environment.volumetric_fog_density = lerp(start_fog_density, target_fog_density, t / duration)
		await get_tree().process_frame
		if t > 2.0 and !wind.playing:
			wind.play()
		if t > 6.0 and !park.playing:
			park.play()
	
	t = 0.0
	while t < 5.0:
		bush1.global_position = bush1pos
		bush2.global_position = bush2pos
		t += get_process_delta_time()
		await get_tree().process_frame
		
		if t > 2.0 and t < 3.0 and !bush2.playing:
			bush2.play()
		
		if t > 1 and t < 3 and !bush1.playing:
			bush1.play()
	
	bush2.stop()
	sun.visible = true
	original_globe_rotation = globe.rotation_degrees
	globe.rotation_degrees = Vector3(-76.7, 16.9, 180)
	
	milkyway.max_alpha = 0.8
	t = 0.0
	while t < 3.0:
		t += get_process_delta_time()
		environment.volumetric_fog_density = lerp(target_fog_density, start_fog_density, t / 2.0)
		await get_tree().process_frame
		
		if t > 2.0:
			wind.stop()
			park.stop()
		
		if t > 0.5 and t < 0.6:
			sun.visible = false

	print(milkyway.visible)
	while camera.rotation_degrees.x < 20.0:
		await get_tree().process_frame
	print('up')
	while camera.rotation_degrees.x > -12.0:
		await get_tree().process_frame
	print('down')
	globe.rotation_degrees = original_globe_rotation
	milkyway.max_alpha = original_milkyway_alpha

	
var played = false
func _physics_process(_delta: float) -> void:
	if 1 in Gamestate.anomalies and !played:
		played = true
		
		fog_fade()
	
	
