extends Node

@onready var book = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_book"):
		book.book_open.emit(!book.visible)
		
