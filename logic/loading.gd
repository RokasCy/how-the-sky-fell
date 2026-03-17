extends Node3D

@onready var animator = $Animations
@onready var ui = $UI_Animations

func _ready():
	animator.play("fade_in")
	ui.play("objective")
	pass 
