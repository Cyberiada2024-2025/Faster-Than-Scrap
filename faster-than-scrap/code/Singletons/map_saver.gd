extends Node

var map_select: MapSelector


func save_map() -> void:
	map_select.get_parent().remove_child(map_select)
