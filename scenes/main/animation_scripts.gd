extends Node

@export var game_logic: Node

var day_to_scene = {
	0 : "res://scenes/main/root.tscn",
	1 : "res://scenes/main/day2.tscn",
	2 : "res://scenes/main/day3.tscn"
}

func change_scene_day():
	get_tree().change_scene_to_file(day_to_scene[game_logic.Night+1])
