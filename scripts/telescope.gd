extends Control

@onready var stars : Node3D = $"../Stars"
@onready var main : Camera3D = $"../Main_camera"
@onready var telescope : Camera3D = $SubViewport/camera
@export_range(0, 90) var fov : int = 30
@export var zoom_speed = 10

func _ready():
	telescope.fov = fov

func _physics_process(delta):
	telescope.global_transform = main.global_transform
	
	if Input.is_action_just_pressed("zoom"):
		visible = true
	if Input.is_action_just_pressed("unzoom"):
		visible = false
		telescope.fov = fov
		
	if Input.is_action_pressed("fov-"):
		telescope.fov -= zoom_speed * delta
	if Input.is_action_pressed("fov+"):
		telescope.fov += zoom_speed * delta
	
	if visible == true:
		angle_to_skycoords(telescope.global_rotation)
		
func angle_to_skycoords(angle):
	var dec_rad = angle.x
	var ra_rad = angle.y
	
	var dec_deg = round(rad_to_deg(dec_rad))
	var ra_deg = round(rad_to_deg(ra_rad))
	
	#print(dec_deg, " ",ra_deg)
	
	
	
		
	
