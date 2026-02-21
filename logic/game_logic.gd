extends Node

@export var Night : int = 0

@onready var book = $"../Book"

var player_can_move = true
var player_visible = true

var book_opened : bool = false
var telescope_zoomed : bool = false
func _on_telescope_zoom(in_or_out: Variant) -> void:
	telescope_zoomed = in_or_out
	update_perms()

func _on_book_open(open_or_close: Variant) -> void:
	if telescope_zoomed:
		return
	book.visible = !book.visible
	book_opened = open_or_close
	update_perms()
	
func update_perms():
	if book_opened or telescope_zoomed:
		player_can_move = false
	else:
		player_can_move = true
	
	if telescope_zoomed:
		player_visible = false
	else:
		player_visible = true
