extends Node3D

@export var period = 1.0
@onready var planet = get_parent()

var speed
func _ready():
	speed = TAU / period

func _physics_process(delta):
	speed = TAU / period
	planet.rotate_y(speed * delta)
