extends Node

@export var ui : Control
@export var raycast : RayCast3D
@export var progressbar : ProgressBar

var planet_chart_value  : Dictionary = {
	'venus_area' : 0, 'mars_area': 0, 'jupiter_area': 0, 'saturn_area': 0
}
var speed : int = 20.0

var unlocked : Dictionary = {
	'venus': false, 'mars': false, 'jupiter': false, 'saturn': false
}

func unlock(pname):
	if pname == 'venus_area':
		unlocked['venus'] = true
	elif pname == 'mars_area':
		unlocked['mars'] = true
	elif pname == 'jupiter_area':
		unlocked['jupiter'] = true
	elif pname == 'saturn_area':
		unlocked['saturn'] = true

func _physics_process(delta: float):
	if !ui.visible:
		return 
		
	if raycast.is_colliding():
		var pname = raycast.get_collider().name
		if !planet_chart_value.has(pname):
			return
		progressbar.visible = true
		progressbar.value = planet_chart_value[pname]
		if Input.is_action_pressed("chart"):
			planet_chart_value[pname] += delta * speed
			if planet_chart_value[pname] >= 100:
				print('end')
	else:
		progressbar.visible = false

		
