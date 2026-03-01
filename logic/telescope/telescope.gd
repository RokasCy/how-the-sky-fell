extends Control

signal star_click(hip)

@onready var stars : Node3D = $"../Stars"

@onready var main : Camera3D = $"../Main_camera"
@onready var telescope : Camera3D = $SubViewport/camera

@export var raycast : RayCast3D
@export_range(0, 90) var fov : int = 30
@export var zoom_speed = 10

var looking_at_hip = 0

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
	
	#if zoomed in
	if visible == true:
		angle_to_skycoords()
		if looking_at_hip == 0:
			return 
		
		if Input.is_action_just_pressed("left_click"): 
			star_click.emit(looking_at_hip)
		
		
func angle_to_skycoords():
	#forward direction of telescope (-Z)
	var forward = -telescope.global_basis.z
	
	#rotation of sky in world space
	var sky_basis = stars.global_basis
	
	#direction of camera in sky_space
	var dir_in_sky_space = sky_basis.inverse() * forward
	
	#dir_in_sky is -1 to 1  asin1 = 90 | asin-1 = -90
	var dec_rad = asin(dir_in_sky_space.y)
	var dec_deg = round(rad_to_deg(dec_rad))
	
	
	var ra_rad = atan2(dir_in_sky_space.x, dir_in_sky_space.z)
	var ra_deg = rad_to_deg(ra_rad) - 90
	if ra_deg < 0:
		ra_deg += 360

	looking_at_hip = 0
	for star in stars.star_data:
		if len(star) <= 1:
			continue
		var star_ra = (star["RA_hour"] + star["RA_min"] / 60 + star["RA_sec"] / 3600) * 15
		var star_dec = star["DEC_deg"] + star["DEC_min"] / 60 + star["DEC_sec"] / 3600 
		
		#looking at star
		if abs(star_ra - ra_deg) < 1 and abs(star_dec - dec_deg) < 1:
			looking_at_hip = star["HIP"]
			break
