class_name SceneLoader

extends Node

## object which loads new scene and informs the game manager 
## of the game game state
## Used as a helper node, so there can be multiple of scene managers in the same scene

func load_main_menu_scene()->void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)

func load_map_selector_scene()->void:
	get_tree().change_scene_to_file("res://scenes/map_selector.tscn")
	GameManager.set_game_state(GameState.State.MAP_SELECTOR)

func load_fly_ship_scene()->void:
	get_tree().change_scene_to_file("res://scenes/fly_ship.tscn")
	GameManager.set_game_state(GameState.State.FLY)


func load_build_ship_scene()->void:
	get_tree().change_scene_to_file("res://scenes/build_ship.tscn")
	GameManager.set_game_state(GameState.State.BUILD)
