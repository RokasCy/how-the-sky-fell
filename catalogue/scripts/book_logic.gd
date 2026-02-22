extends Node

@export var stars: Node3D

func _physics_process(delta: float) -> void:
	print(stars.constellations_finished)
