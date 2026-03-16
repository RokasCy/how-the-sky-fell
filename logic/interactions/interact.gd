extends Area3D

signal telescope_interact()
signal telescope_pickup()

@export var interaction_type : String = ""
@export var zone : float = 10.0
@export var text_node_main : Label
@export var text_node2 : Label

@onready var collision = $CollisionShape3D
var interactable : bool = false
var picked_up : bool = false


func _ready() -> void:
	collision.shape.radius = zone
	text_node_main.visible = false
	text_node2.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		interactable = true
		if !picked_up:
			text_node_main.visible = true
		
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		interactable = false
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
	

			
		
