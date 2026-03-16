extends Node3D

signal zoom(in_or_out)
signal star_click(hip)
signal chart(planet)

@onready var control = $Control
@onready var coord_label = $Control/Cords
@onready var camera = $Control/SubViewport/Camera3D
@onready var body = $Main
@onready var player = $"../Player"
@onready var collider1 = $StaticBody3D/CollisionShape3D
@onready var collider2 = $StaticBody3D/CollisionShape3D2

#angular speed
@export var speed : float = 0.5
var zoom_speed = speed
var zoom_type = 1
var zoomed_fov : int

var zoomed_in = false
var picked_up = false

var tween : Tween

var offset = Vector3(0.0, 0.275, -0.2)
func _ready() -> void:
	control.visible = false
	camera.position = position + offset
	print(speed)
	
func _on_interaction_telescope() -> void:
	control.visible = !control.visible
	zoom.emit(control.visible)
	
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
			camera.rotation.y = player.camera.rotation.y
			


func _physics_process(delta: float):	
	if picked_up:	
		position = player.position 
		translate(Vector3(0.0, 0.0, 15.0))
		rotation.y = player.camera.rotation.y + PI
		
		
	zoomed_in = control.visible
	if !zoomed_in:
		return
	#--rotation--#
	if Input.is_action_pressed("forward"):
		camera.rotation.x += zoom_speed*delta
	elif Input.is_action_pressed("backward"):
		camera.rotation.x -= zoom_speed*delta
	elif Input.is_action_pressed("left"):
		camera.rotation.y += zoom_speed*delta
	elif Input.is_action_pressed("right"):
		camera.rotation.y -= zoom_speed*delta
	
	#-- zoom --#
	
	if Input.is_key_pressed(KEY_M):
		for key in [KEY_1, KEY_2, KEY_3, KEY_4]:
			if Input.is_key_pressed(key):
				change_zoom(key - KEY_0)
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -20, 85)
	body.global_rotation.x = PI/2 - camera.global_rotation.x
	body.global_rotation.y = camera.global_rotation.y + PI
	
	
	update_UI()
	zoomed_fov = camera.fov
	
func change_zoom(key):
	if key == 1 and zoom_type != 1:
		zoom_speed = speed * 0.75
		zoom_type = 1
		
		tween = create_tween()
		tween_fov(tween, 30, 1.0)
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
