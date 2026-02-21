extends Control

signal book_open(open_or_close)

@onready var animator = $BookAnimation
@onready var cover = $Cover

@onready var left_page = $Left_page
@onready var right_page = $Right_page

@onready var left_title = $Left_page/Title
@onready var right_title = $Right_page/Title

@onready var left_text = $"Left_page/PageText"
@onready var right_text = $"Right_page/PageText"

@onready var left_number = $"Left_page/number"
@onready var right_number = $"Right_page/number"

@export var pages : Array[PageData]
var current_page := 0

func _ready():
	visible = false
	animator.play("CenterBook")
	cover.visible = false

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
	
	
	left_title.text = left_page_info.title
	right_title.text = right_page_info.title
	
	left_text.text = left_page_info.text
	right_text.text = right_page_info.text
	
	left_number.text = left_page_info.number
	right_number.text = right_page_info.number

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
		show_spread()
