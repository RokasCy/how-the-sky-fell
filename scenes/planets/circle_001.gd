extends MeshInstance3D

@onready var message = $"../anomaly1"
@onready var horn = $"../anomaly2"
@onready var wind = $"../anomaly3"
@onready var environment = $"../../../../../WorldEnvironment".environment

@onready var saturn = get_parent()
var played = false
func _physics_process(delta: float) -> void:
	if 1 in Gamestate.anomalies and !played:
		played = true
		visible = false
		environment.volumetric_fog_enabled = true
		message.play()
		
		wind.play()
		await message.finished
		message.play()
		horn.play()
		await message.finished
		message.play()
		await message.finished
		message.play()
		await message.finished
		
		horn.stop()
		wind.stop()
		
		visible = true
		environment.volumetric_fog_enabled = false
	
	
