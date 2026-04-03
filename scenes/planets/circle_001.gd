extends MeshInstance3D

@onready var message = $"../anomaly1"
@onready var park = $"../anomaly2"
@onready var wind = $"../anomaly3"

@onready var bush1 = $"../anomaly4"
@onready var bush2 = $"../anomaly5"
@onready var environment = $"../../../../../WorldEnvironment".environment

@onready var saturn = get_parent()
#var ring_mat = load("res://scenes/planets/saturn.tscn::StandardMaterial3D_fpsqh")

var bush1pos = Vector3(12.46469, 1.017148, 5.294871)
var bush2pos = Vector3(-15.22458, 0.975708, -5.983067)

func fog_fade():
	bush1.global_position = bush1pos
	bush2.global_position = bush2pos
	
	var duration = 20.0
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
		if t > 9.0 and !park.playing:
			park.play()
	
	t = 0.0
	while t < 20.0:
		bush1.global_position = bush1pos
		bush2.global_position = bush2pos
		t += get_process_delta_time()
		await get_tree().process_frame
		
		if t > 12.0 and t < 14.0 and !bush2.playing:
			bush2.play()
			print('play2')
		
		if t > 5.0 and t < 7.0 and !bush1.playing:
			print('play1')
			bush1.play()
		
		if t > 18.0 and t < 19.0 and !bush1.playing:
			print('play1')
			bush1.play()
	
	bush2.stop()
	print('hi')
	t = 0.0
	while t < 2.0:
		t += get_process_delta_time()
		environment.volumetric_fog_density = lerp(target_fog_density, start_fog_density, t / 2.0)
		await get_tree().process_frame
		
		if t > 1.0:
			wind.stop()
			park.stop()
	
	
var played = false
func _physics_process(_delta: float) -> void:
	if 1 in Gamestate.anomalies and !played:
		played = true
		
		fog_fade()
	
	
