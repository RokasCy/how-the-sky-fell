extends Control


@onready var parent = get_parent()
@onready var stars : Node3D = $"../../Player/Stars"
@onready var camera : Camera3D = $SubViewport/Camera3D

@onready var star_chime = $"../star_chime"

var angle_coord : Array
func _physics_process(delta):
	#---- how telescope_logic connects to constellation line draw ----#
	if visible == true:
		var hip = angle_to_hip()
		if Input.is_action_just_pressed("telescope_click") and hip!=0: 
			star_chime.play()
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
		var star_ra = (star["RA_hour"] + star["RA_min"] / 60.0 + star["RA_sec"] / 3600.0) * 15
		var star_dec = abs(star["DEC_deg"]) + abs(star["DEC_min"] / 60.0) + abs(star["DEC_sec"] / 3600.0)
		if star["DEC_deg"] < 0:
			star_dec = -star_dec
		#looking at star
		if abs(star_ra - ra_deg) < 1 and abs(star_dec - dec_deg) < 1:
			looking_at_hip = star["HIP"]

			break
	return looking_at_hip

func degree_to_full_cord(ra, dec):
	#godot: 15 / 6 integer division by default
	# 15 / 6.0 float division
	var sign = sign(dec)
	var dec_abs = abs(dec)
	
	var dec_deg = int(dec_abs)
	var dec_min = int((dec_abs - dec_deg) * 60)
	var dec_sec = int((dec_abs - dec_deg) * 3600 - dec_min * 60)
	
	dec_deg *= int(sign)

	var ra_hours_total = ra / 15.0
	var ra_hour = int(ra_hours_total)
	var ra_min = int((ra_hours_total - ra_hour) * 60)
	var ra_sec = int((ra_hours_total - ra_hour) * 3600 - ra_min * 60)
	
	return [[ra_hour, ra_min, ra_sec], [dec_deg, dec_min, dec_sec]]
