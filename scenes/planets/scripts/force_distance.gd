extends Node3D

@export var distance : int = 1000
func _ready() -> void:
	var direction = global_position.normalized()
	global_position = direction * distance
	
