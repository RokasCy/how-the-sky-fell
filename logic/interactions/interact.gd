extends Area3D

signal telescope_interact()

@export var interaction_type : String = ""
@export var zone : float = 10.0

@onready var collision = $CollisionShape3D
var interactable : bool = false

func _ready() -> void:
	collision.shape.radius = zone
	print(collision.shape.radius)

func _on_body_entered(body: Node3D) -> void:
	interactable = true
	
func _on_body_exited(body: Node3D) -> void:
	interactable = false

func telescope_interaction():
	telescope_interact.emit()
	
func _physics_process(delta: float) -> void:
	if interactable and Input.is_action_just_pressed("interact"):
		if interaction_type == "telescope":
			telescope_interaction()
			
		
