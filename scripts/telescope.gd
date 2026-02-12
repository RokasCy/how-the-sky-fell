extends Control

@onready var stars : Node3D = $"../Stars"

@onready var main : Camera3D = $"../Main_camera"
@onready var telescope : Camera3D = $SubViewport/camera
@export_range(0, 90) var fov : int = 30
@export var zoom_speed = 10

var star_coords_dict = {}

var cord_squish = 10



func _ready():
	telescope.fov = fov
	
	for star in stars.star_data:
		if len(star) <= 1:
			continue
		if star["HIP"] != 24608.0:
			continue
		
		var ra = star["RA_hour"] + star["RA_min"] / 60 + star["RA_sec"] / 3600
		
		var ra_ = round(ra * cord_squish)
		var dec_ = round(star["DEC_deg"] / 15 * cord_squish)
		star_coords_dict[[ra_, dec_]] = star
	
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
		angle_to_skycoords()
		
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
		
	var ra_hour = round(ra_deg / 15)
	
	var coord_id = [ra_hour * cord_squish, round(dec_deg / 15 * cord_squish)]
	if coord_id in star_coords_dict:
		var hip = star_coords_dict[coord_id]["HIP"]
		print('found')
	
	
	print(coord_id)
