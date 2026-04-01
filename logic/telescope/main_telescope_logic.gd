extends Node3D

signal zoom(in_or_out)
signal star_click(hip)
signal chart(planet)

@onready var control = $Control
@onready var animations = $AnimationPlayer

@onready var coord_label = $Control/Cords
@onready var keyboard_tip = $"Control/press j"

@onready var camera = $Control/SubViewport/Camera3D
@onready var body = $Main
@onready var player = $"../Player"
@onready var collider1 = $StaticBody3D/CollisionShape3D
@onready var collider2 = $StaticBody3D/CollisionShape3D2


@onready var sfx = $sfx

#angular speed
@export var speed : float = 0.5
var zoom_speed = speed
var zoom_type = 1
var zoomed_fov : int

var zoomed_in = false
var picked_up = false

var tween : Tween

var tips_shown = 0

var offset = Vector3(0.0, 0.275, -0.2)
func _ready() -> void:
	control.visible = false
	camera.position = position + offset
	print(speed)
	
func _on_interaction_telescope() -> void:
	control.visible = !control.visible
	zoom.emit(control.visible)
	
	sfx.play()
	
	zoomed_in = control.visible
	if zoomed_in and tips_shown < 4:
		if !animations.is_playing():
			animations.play("fade_in_tips")
	
	#make shadows visible
	if control.visible:
		body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	else:
		body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON


func _on_telescope_pickup() -> void:
	if !zoomed_in and player.is_on_floor():
		if !picked_up:
			visible = true
			picked_up = true
		else:
			visible = true
			picked_up = false
			camera.position = position + offset
			#camera.rotation.y = player.camera.rotation.y
			
			#body.rotation.x = camera.rotation.x + PI/2
			#body.rotation.y = camera.rotation.y
			


func _physics_process(delta: float):	
	if picked_up:	
		var camera_basis = Vector3(player.camera.global_basis.z.x, 0, player.camera.global_basis.z.z)
		position = player.position + camera_basis * -2.0		
		#rotation.y = player.camera.rotation.y + PI
		
		
	#zoomed_in = control.visible
	if !zoomed_in:
		return
	#--rotation--#
	if Input.is_action_pressed("forward"):
		camera.rotation.x += zoom_speed*delta
		body.rotation.x -= zoom_speed*delta
	elif Input.is_action_pressed("backward"):
		camera.rotation.x -= zoom_speed*delta
		body.rotation.x += zoom_speed*delta
	elif Input.is_action_pressed("left"):
		camera.rotation.y += zoom_speed*delta
		body.rotation.y += zoom_speed*delta
	elif Input.is_action_pressed("right"):
		camera.rotation.y -= zoom_speed*delta
		body.rotation.y -= zoom_speed*delta
	
	#-- zoom --#
	if Input.is_key_pressed(KEY_M):
		for key in [KEY_1, KEY_2, KEY_3, KEY_4]:
			if Input.is_key_pressed(key):
				change_zoom(key - KEY_0)
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -20, 85)
	body.rotation_degrees.x = clamp(body.rotation_degrees.x, 5, 110)
	#body.rotation.x = PI/2 - camera.rotation.x
	#body.rotation.y = camera.rotation.y + PI
	
	
	update_UI()
	zoomed_fov = camera.fov
	
func change_zoom(key):
	if key == 1 and zoom_type != 1:
		zoom_speed = speed * 0.75
		zoom_type = 1
		
		tween = create_tween()
		tween_fov(tween, 50, 1.0)
	if key == 2 and zoom_type != 2:
		zoom_speed = speed * 0.4
		zoom_type = 2
		
		tween = create_tween()
		tween_fov(tween, 15, 1.0)
	if key == 3 and zoom_type != 3:
		zoom_speed = speed * 0.2
		zoom_type = 3
		
		tween = create_tween()
		tween_fov(tween, 5, 1.0)
	if key == 4 and zoom_type != 4:
		zoom_speed = speed * 0.1
		zoom_type = 4
		
		tween = create_tween()
		tween_fov(tween, 1, 1.0)

func tween_fov(tween, fov, dur):
	tween.tween_property(camera, "fov", fov, dur) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	zoomed_fov = camera.fov

var update_delay = 5
var update_count = 0
func update_UI():
	if update_count != update_delay:
		update_count += 1
		return
	var flat = control.angle_coord[0] + control.angle_coord[1]
	coord_label.text = "ra/dec:{0}h{1}'{2}\"/{3}°{4}'{5}\"" \
	.format(flat)
	
	update_count = 0
