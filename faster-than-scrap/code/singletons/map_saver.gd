extends Node

## Singleton for saving the map used for selecting next nodes (map_select).

var map_select: MapSelector


func save_map() -> void:
	map_select.get_parent().remove_child(map_select)

func reset() -> void:
	map_select = null
