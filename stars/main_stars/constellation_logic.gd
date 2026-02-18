extends Node

@onready var main = get_parent()

var night_targets = [["Ori", "Cas", "And", "Per"]]
var current_targets = []

func _ready():
	update_targets()

func update_targets():
	var n = main.Night
	current_targets = night_targets[n]
