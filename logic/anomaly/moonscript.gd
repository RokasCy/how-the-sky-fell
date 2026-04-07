extends MeshInstance3D

@onready var moonnoise = $"../AudioStreamPlayer3D"

@onready var camera = $"../../../../Main_camera"
@onready var telescope_cam = $"../../../../../telescope/Control/SubViewport/Camera3D"
@onready var telescope_ui = $"../../../../../telescope/Control"

var spin_speed = 0.0
var spinning = false
var stop = false
func spin():
	if !spinning:
		return 
	
	if spin_speed == 16.0:
		stop = true
		
	var delta = get_process_delta_time()
	rotate_y(spin_speed * delta)
	spin_speed += 0.015
	spin_speed = min(spin_speed, 16.0)

var moon_gone = false
func _physics_process(_delta: float) -> void:
	if 3 in Gamestate.anomalies:
		var cam_forward
		if is_instance_valid(telescope_ui) and telescope_ui.visible:
			cam_forward = -telescope_cam.global_basis.z.normalized()
		else:	
			cam_forward = -camera.global_basis.z.normalized()
			
		var to_target = (global_position - camera.global_position).normalized()
		
		var dot = cam_forward.dot(to_target)
		var db = (dot - 0.4)**3 * 60

		if (stop and dot > 0.94) or moon_gone:
			visible = false
			moonnoise.stop()
			moon_gone = true
			return 
		
		moonnoise.volume_db = db
		visible = true
		
		if dot > 0.97:
			spinning = true
		spin()
		
		if !moonnoise.playing:
			moonnoise.play()
		
		
