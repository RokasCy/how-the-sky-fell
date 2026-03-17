extends Control

@onready var animator = $Animations

func _on_play_pressed() -> void:
	animator.play("fade_out")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://scenes/main/root.tscn")

func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	animator.play("fade_out")
	await animator.animation_finished
	get_tree().quit()
