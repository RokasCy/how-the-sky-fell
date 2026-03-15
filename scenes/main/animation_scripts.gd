extends Node

@export var game_logic: Node

var day_to_scene = {
	0 : "uid://ci5hir3ycucwr", 
	1 : "uid://cc67t5yshhke6"
}

func change_scene_day():
	get_tree().change_scene_to_file(day_to_scene[game_logic.Night+1])
