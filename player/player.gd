extends CharacterBody3D

@export_range(0.0, 1.0) var mouse_sensitivity := 0.35

@export var speed := 40
@export var jump_speed := 15
@export var gravity := -0.5

@onready var camera = $Main_camera
@onready var logic = $"../Game logic"
@onready var player_mesh = $MeshInstance3D

var _camera_input_direction := Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#---------CAMERA HANDLING---------#

func _unhandled_input(event: InputEvent) -> void:
	var camera_in_motion = (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if camera_in_motion:
		_camera_input_direction = event.relative * mouse_sensitivity
	
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if logic.telescope_zoomed:
		return
	
	camera.rotation.x -= _camera_input_direction.y * delta
	camera.rotation.y -= _camera_input_direction.x * delta
	camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)
	
	_camera_input_direction = Vector2.ZERO
	
	#---movement---#
	
	var raw_input = Input.get_vector("left", "right", "forward", "backward")
	var forward_axis : Vector3 = camera.global_basis.z
	var right_axis : Vector3 = camera.global_basis.x
	
	var move_direction = forward_axis * raw_input.y + right_axis * raw_input.x
	move_direction = move_direction.normalized()
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_speed
		else:
			velocity.y = 0
	else:
		velocity.y += gravity
	
	move_and_slide()

func _on_telescope_zoom(in_or_out: Variant) -> void:
	player_mesh.visible = !in_or_out
	
