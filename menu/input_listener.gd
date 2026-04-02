extends Node

@onready var exit_txt = $"../Press"
@onready var animator = $"../Animations"
var clicks = 0

func _ready():
	exit_txt.visible = false
	if animator != null:
		animator.play_backwards("fade_out")
		get_parent().visible = true
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			clicks+=1
			exit_txt.visible = true
			if clicks>1:
				get_tree().quit()
