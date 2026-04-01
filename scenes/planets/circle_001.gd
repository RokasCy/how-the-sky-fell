extends MeshInstance3D

@onready var sfx = $"../anomaly1"
var played = false
func _physics_process(_delta: float) -> void:
	if 1 in Gamestate.anomalies and !played:
		visible = false
		played = true
		sfx.play()
		await sfx.finished
		visible = true
	
	
