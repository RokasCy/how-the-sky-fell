extends Node

@onready var main = get_parent()

var night_targets = [
	["Ori", "Tau", "Aur", "Gem"], 
	["Cnc", "Leo", "Hya", "Vir"], 
	["Boo", "Dra", "UMa", "UMi"]
]
var current_targets = []

func _ready():
	update_targets()

func update_targets():
	var n = main.Night
	current_targets = night_targets[n]
