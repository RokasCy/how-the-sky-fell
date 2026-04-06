extends Node

@export var Night : int = 0

@export_category("Nodes")
@export var telescope: Node3D
@export var book : Control
@export var maps : Control

var player_can_move = true
var player_visible = true

var book_opened : bool = false
var can_map_open : bool = false
var telescope_zoomed : bool = false
var map_opened : bool = false
var zoomed_fov : int 

func _physics_process(delta: float) -> void:
	if is_instance_valid(telescope):
		zoomed_fov = telescope.zoomed_fov

func _on_telescope_zoom(in_or_out: Variant) -> void:
	telescope_zoomed = in_or_out
	update_perms()

func _on_book_open(open_or_close: Variant) -> void:
	if telescope_zoomed:
		return
	book.visible = !book.visible
	book_opened = open_or_close
	update_perms()


func _on_map_interact(open: Variant) -> void:
	if telescope_zoomed or !can_map_open:
		return
	map_opened = open
	maps.visible = open
	if map_opened:
		pass
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		pass
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_perms()
	
func update_perms():
	if book_opened or telescope_zoomed or map_opened:
		player_can_move = false
	else:
		player_can_move = true
	
	if telescope_zoomed:
		player_visible = false
	else:
		player_visible = true


func _on_papers_picked_up() -> void:
	can_map_open = true
