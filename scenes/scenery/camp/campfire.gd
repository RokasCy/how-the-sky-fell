extends Node3D
@onready var flames = $flames
@onready var smoke = $smoke
@onready var lights = $OmniLight3D
@onready var crackle = $"fire crackle"

func _on_interaction_fire_burn_change() -> void:
	flames.visible = !flames.visible
	smoke.visible = !smoke.visible
	lights.visible = !lights.visible
	if crackle.playing:
		crackle.stop()
	else:
		crackle.play()
	print('change')
