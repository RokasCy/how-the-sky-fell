extends Node3D

@onready var animator = $Animations


func _ready():
	animator.play("fade_in")	
	pass 
