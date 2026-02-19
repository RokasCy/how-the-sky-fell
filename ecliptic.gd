extends MeshInstance3D


func _physics_process(_delta):
	if Input.is_action_pressed('left_click'):
		self.rotate_x(-0.005)
		print(self.rotation_degrees)
	if Input.is_action_pressed('right_click'):
		self.rotate_x(0.005)
		print(self.rotation_degrees)
	if Input.is_action_pressed("forward"):
		self.rotate_z(-0.005)
		print(self.rotation_degrees)
	if Input.is_action_pressed("backward"):
		self.rotate_z(0.005)
		print(self.rotation_degrees)
	
