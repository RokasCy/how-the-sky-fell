extends Area3D

signal telescope_interact()
signal telescope_pickup()

@export var interaction_type : String = ""
@export var zone : float = 10.0

@onready var collision = $CollisionShape3D
var interactable : bool = false


func _ready() -> void:
	collision.shape.radius = zone

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		interactable = true
		print('etner')
	
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		interactable = true
		print('exit')

func telescope_interaction():
	telescope_interact.emit()

func telescope_picking_up():
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
	

			
		
