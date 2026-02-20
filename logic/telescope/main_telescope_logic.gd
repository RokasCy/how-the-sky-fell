extends Node3D

signal zoom(in_or_out)
signal star_click(hip)

@onready var control = $Control
@onready var camera = $Control/SubViewport/Camera3D
@onready var body = $Main

@export var speed : float = 1.0

func _ready() -> void:
	control.visible = false
	
	var offset = Vector3.UP
	camera.position = position 

func _on_interaction_telescope() -> void:
	control.visible = !control.visible
	body.visible = !control.visible
	zoom.emit(control.visible)

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
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -20, 85)
