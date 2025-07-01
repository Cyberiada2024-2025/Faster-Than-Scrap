extends Node

## Singleton for saving the map used for selecting next nodes (map_select).

var map_select: MapSelector


func _ready():
	GameManager.game_reset.connect(_on_game_manager_reset)


func _on_game_manager_reset():
	map_select = null


func save_map() -> void:
	map_select.get_parent().remove_child(map_select)
