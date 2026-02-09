extends DirectionalLight3D

var time_of_day := 0.0
var rate_of_cycle := 1.0

func _process(delta: float) -> void:
	time_of_day += delta * rate_of_cycle
	if time_of_day > 24:
		time_of_day = 0
	
	self.rotation_degrees.x = lerp(-90, 270, time_of_day / 24)
	print(self.rotation_degrees.x)
