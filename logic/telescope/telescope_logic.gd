extends Control


@onready var parent = get_parent()
@onready var stars : Node3D = $"../../Player/Stars"
@onready var camera : Camera3D = $SubViewport/Camera3D

var angle_coord : Array

func _physics_process(delta):
	#---- how telescope_logic connects to constellation line draw ----#
	if visible == true:
		var hip = angle_to_hip()
		if Input.is_action_just_pressed("telescope_click") and hip!=0: 
			parent.star_click.emit(hip)
		
		
func angle_to_hip():
	#forward direction of telescope (-Z)
	var forward = -camera.global_basis.z
	
	#rotation of sky in world space
	var sky_basis = stars.global_basis
	
	#direction of camera in sky_space
	var dir_in_sky_space = sky_basis.inverse() * forward
	
	#dir_in_sky is -1 to 1  asin1 = 90 | asin-1 = -90
	var dec_rad = asin(dir_in_sky_space.y)
	var dec_deg = rad_to_deg(dec_rad)
	
	
	var ra_rad = atan2(dir_in_sky_space.x, dir_in_sky_space.z)
	var ra_deg = rad_to_deg(ra_rad) - 90
	if ra_deg < 0:
		ra_deg += 360
	
	angle_coord = degree_to_full_cord(ra_deg, dec_deg)
	
	var looking_at_hip = 0
	for star in stars.star_data:
		if len(star) <= 1:
			continue
		var star_ra = (star["RA_hour"] + star["RA_min"] / 60 + star["RA_sec"] / 3600) * 15
		var star_dec = star["DEC_deg"] + star["DEC_min"] / 60 + star["DEC_sec"] / 3600 
		
		#looking at star
		if abs(star_ra - ra_deg) < 1 and abs(star_dec - dec_deg) < 1:
			looking_at_hip = star["HIP"]
			break
	return looking_at_hip

func degree_to_full_cord(ra, dec):
	var dec_remain = int(round(dec * 3600))
	var dec_deg = int(dec_remain / 3600)
	dec_remain %= 3600
	var dec_min = int(dec_remain / 60)
	dec_remain %= 60
	var dec_sec = dec_remain
	
	var ra_remain = int(round(ra * 3600))
	var ra_hour = int((ra_remain / 3600) / 15) 
	ra_remain %= 3600
	var ra_min = int(ra_remain / 60)
	ra_remain %= 60
	var ra_sec = ra_remain
	
	return [[ra_hour, ra_min, ra_sec], [dec_deg, dec_min, dec_sec]]
