extends Node3D

@onready var animator = $Animations
@onready var ui = $UI_Animations

func _ready():
	if animator != null:
		animator.play("fade_in")
	if ui != null:
		ui.play("objective")
	pass 

func end_card():
	get_tree().change_scene_to_file("res://menu/end_card.tscn")
