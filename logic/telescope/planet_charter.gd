extends Node

@onready var parent = get_parent()
@export var ui : Control
@export var raycast : RayCast3D
@export var progressbar : ProgressBar

@onready var writing = $"../AudioStreamPlayer3D"

var planet_chart_value  : Dictionary = {
	'venus' : 0, 'mars': 0, 'jupiter': 0, 'saturn': 0
}
var speed : int = 20.0

var sat_anomaly = false

func _physics_process(delta: float):
	if !ui.visible:
		return 
		
	if raycast.is_colliding():
		var pname = raycast.get_collider().name
		if !planet_chart_value.has(pname):
			return
		
		if planet_chart_value[pname] >= 100:
			progressbar.visible = false
			writing.stop()
			return
			
		progressbar.visible = true
		progressbar.value = planet_chart_value[pname]
		
		if pname == 'saturn' and planet_chart_value[pname] >= 60.0:
			if 1 not in Gamestate.anomalies:
				Gamestate.anomalies.append(1)

				
			
		
		if Input.is_action_pressed("chart"):
			if !writing.playing:
				writing.play()
			planet_chart_value[pname] += delta * speed
			if planet_chart_value[pname] >= 100:
				parent.chart.emit(pname)
		else:
			writing.stop()
	
	else:
		progressbar.visible = false
		writing.stop()
		

		
