extends Node

@export var Night : int = 0

var telescope_zoomed : bool = false
func _on_telescope_zoom(in_or_out: Variant) -> void:
	telescope_zoomed = in_or_out
