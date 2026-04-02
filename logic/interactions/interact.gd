extends Area3D

signal telescope_interact()
signal telescope_pickup()
signal papers_picked_up()

@export var interaction_type : String = ""
@export var zone : float = 10.0
@export var text_node_main : Label
@export var text_node2 : Label

@onready var collision = $CollisionShape3D
@export var pickupsfx : AudioStreamPlayer3D
var interactable : bool = false
var picked_up : bool = false


func _ready() -> void:
	collision.shape.radius = zone
	if text_node_main != null:
		text_node_main.visible = false
	if text_node2 != null:
		text_node2.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		interactable = true
		if !picked_up:
			if text_node_main != null:
				text_node_main.visible = true
		
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		if !picked_up:
			interactable = false
		if text_node_main != null:
			text_node_main.visible = false

func telescope_interaction():
	if picked_up:
		return
	
	telescope_interact.emit()

func telescope_picking_up():
	picked_up = !picked_up
	if picked_up:
		text_node_main.visible = false
	text_node2.visible = !text_node2.visible
	telescope_pickup.emit()



func paper_pickup():
	var papers =  $"../../picnic_table/papers"
	papers.visible = false
	text_node_main.text = "Press Tab to Open Maps"
	
	pickupsfx.play()
	papers_picked_up.emit()

var pickup_time = 1.0
var pressing_time = 0.0
func _physics_process(delta: float) -> void:
	
	
	if !interactable:
		return
	if interaction_type == "telescope":
		if Input.is_action_just_pressed("interact"):
			telescope_interaction()
		if Input.is_action_pressed("pickup"):
			pressing_time += delta
			if pressing_time >= pickup_time:
				telescope_picking_up()
				pressing_time = 0.0
		else:
			pressing_time = 0.0
	
	if interaction_type == "paper":
		if Input.is_action_just_pressed("interact"):
			paper_pickup()
			
	

			
		
