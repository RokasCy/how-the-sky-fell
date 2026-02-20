extends Node3D

@onready var control = $Control
@onready var camera = $Control/SubViewport/Camera3D

@export var speed : float = 1.0

func _ready() -> void:
	control.visible = false
	camera.position = position

func _on_interaction_telescope() -> void:
	control.visible = !control.visible

func _physics_process(delta: float):
	var zoomed_in = control.visible
	if !zoomed_in:
		return
	
	if Input.is_action_pressed("forward"):
		camera.rotate_x(-1.0 * delta)
	elif Input.is_action_pressed("backward"):
		camera.rotate_x(1.0 * delta)
	elif Input.is_action_pressed("left"):
		camera.rotate_y(1.0 * delta)
	elif Input.is_action_pressed("right"):
		camera.rotate_y(-1.0 * delta)
	
	camera.rotation.z = 0
