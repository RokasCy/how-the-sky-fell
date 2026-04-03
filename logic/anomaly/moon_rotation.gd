extends MeshInstance3D

@onready var rotator = $rotator

func _ready():
	rotator.period = 30
func _physics_process(delta: float) -> void:
	rotator.period -= delta*2
	rotator.period = max(4.0, rotator.period)
	#print(rotator.period)
