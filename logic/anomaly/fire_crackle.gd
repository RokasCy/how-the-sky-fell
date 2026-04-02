extends AudioStreamPlayer3D
var played = false
func _physics_process(delta: float) -> void:
	if 1 in Gamestate.anomalies and !played:
		stop()
		await get_tree().create_timer(10.0).timeout
		play()
		played = true
