extends Node




func _on_telescope_star_click(hip: Variant) -> void:
	print(hip)
	if hip == 24608.0:
		Gamestate.anomalies.append(3)
