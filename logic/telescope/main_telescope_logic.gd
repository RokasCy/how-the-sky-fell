extends Node3D

signal zoom(in_or_out)
signal star_click(hip)

@onready var control = $Control
@onready var camera = $Control/SubViewport/Camera3D
@onready var body = $Main


@export var speed : float = 1.0

var zoom_type = 0

var invis_mat : StandardMaterial3D
func _ready() -> void:
	control.visible = false
	
	var offset = Vector3(0.0, 0.275, -0.2)
	camera.position = position + offset
	
	invis_mat = load("res://assets/material/invisible.tres").duplicate()

func _on_interaction_telescope() -> void:
	control.visible = !control.visible
	zoom.emit(control.visible)
	
	#make shadows visible
	if control.visible:
		body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	else:
		body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	
func _physics_process(delta: float):
	var zoomed_in = control.visible
	if !zoomed_in:
		return
	
	if Input.is_action_pressed("forward"):
		camera.rotation.x += speed*delta
	elif Input.is_action_pressed("backward"):
		camera.rotation.x -= speed*delta
	elif Input.is_action_pressed("left"):
		camera.rotation.y += speed*delta
	elif Input.is_action_pressed("right"):
		camera.rotation.y -= speed*delta
	
	#-- zoom --#
	
	if Input.is_key_pressed(KEY_M):
		if Input.is_key_pressed(KEY_1):
			if zoom_type == 1:
				return 
			camera.fov = 45
			zoom_type = 1
		if Input.is_key_pressed(KEY_2):
			if zoom_type == 2:
				return 
			camera.fov = 20
			zoom_type = 2
		if Input.is_key_pressed(KEY_3):
			if zoom_type == 3:
				return 
			camera.fov = 5
			zoom_type = 3
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -20, 85)
	body.rotation.x = PI/2 - camera.rotation.x
	body.rotation.y = camera.rotation.y + PI
