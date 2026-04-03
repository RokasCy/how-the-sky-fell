extends ColorRect

var current_level_in = 1.0
func levels_fade_in():
	while current_level_out >= 1.0:
		material.set("shader_parameter/levels", current_level_in)
		current_level_in += 1.0

		await get_tree().create_timer(0.1).timeout
	current_level_in = 1.0

var current_level_out = 16.0
func levels_fade_out():
	while current_level_out >= 2.0:
		material.set("shader_parameter/levels", current_level_out)
		current_level_out -= 1.0
		
		await get_tree().create_timer(0.1).timeout
	current_level_out = 16.0
