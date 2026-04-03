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
	print(spin_speed)

func _physics_process(_delta: float) -> void:
	if 3 in Gamestate.anomalies:
		if stop:
			visible = false
			moonnoise.stop()
			return 
		var cam_forward
		if telescope_ui.visible:
			cam_forward = -telescope_cam.global_basis.z.normalized()
		else:	
			cam_forward = -camera.global_basis.z.normalized()
			
		var to_target = (global_position - camera.global_position).normalized()
		
		var dot = cam_forward.dot(to_target)
		var db = (dot - 0.4)**3 * 60
		
		moonnoise.volume_db = db
		visible = true
		#print(dot)
		
		if dot > 0.97:
			spinning = true
		spin()
		
		if !moonnoise.playing:
			moonnoise.play()
		
		
