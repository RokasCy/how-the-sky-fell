extends Control

signal book_open(open_or_close)

@onready var animator = $BookAnimation
@onready var cover = $Cover

@onready var left_page = $Left_page
@onready var right_page = $Right_page

@export var stars: Node3D

@export var pages : Array[PageData]
var current_page := 0

var left_nodes: Dictionary
var right_nodes: Dictionary
func _ready():
	visible = false
	animator.play("CenterBook")
	cover.visible = false
	
	left_nodes = get_page_nodes(left_page)
	right_nodes = get_page_nodes(right_page)

func get_page_nodes(page) -> Dictionary:
	return {
		"title": page.get_node("Title"),
		"text": page.get_node("PageText"),
		"image": page.get_node("Image"),
		"number": page.get_node("Number")
	}

var default_page = load("res://catalogue/pages/paper_texture01.png")
func show_spread():
	var left_page_info = pages[current_page]
	var right_page_info = pages[current_page + 1]
	
	#--texture--#
	if left_page_info.texture == null:
		left_page.texture = default_page
	else:
		left_page.texture = left_page_info.texture
		
	if right_page_info.texture == null:
		right_page.texture = default_page
	else:
		right_page.texture = right_page_info.texture
	
	
	left_nodes["title"].text = left_page_info.title
	right_nodes["title"].text = right_page_info.title
	
	left_nodes["text"].text = left_page_info.text
	right_nodes["text"].text= right_page_info.text
	
	left_nodes["image"].texture = left_page_info.image
	right_nodes["image"].texture = right_page_info.image
	
	left_nodes["number"].text= left_page_info.number
	right_nodes["number"].text= right_page_info.number

func _input(event: InputEvent) -> void:
	if !visible:
		return
	if event.is_action_pressed("left_click"):
		next_page()
	if event.is_action_pressed("right_click"):
		previous_page()
	
func next_page():
	if current_page == 0:
		cover.visible = true
		animator.play("Uncenter")
	current_page += 2
	current_page = clamp(current_page, 0, 4)
	show_spread()
	
func previous_page():
	current_page -= 2
	if current_page == 0:
		animator.play("CenterBook")
		cover.visible = false
	current_page = clamp(current_page, 0, 4)
	show_spread()

func _on_book_open(open_or_close: Variant) -> void:
	if open_or_close:
		visible = true
		show_spread()
	else:
		visible =false
