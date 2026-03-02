extends DirectionalLight3D

func _physics_process(_delta: float) -> void:
	look_at(Vector3(0, 0, 0), Vector3.UP)
	if global_position.y < 1:
		visible = false
	else:
		visible = true
		
