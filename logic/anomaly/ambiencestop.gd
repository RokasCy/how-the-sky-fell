extends AudioStreamPlayer3D

func _physics_process(delta: float) -> void:
	if 4 in Gamestate.anomalies:
		stop()
