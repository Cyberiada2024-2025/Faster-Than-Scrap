class_name SceneLoader

extends Node

## object which loads new scene and informs the game manager
## of the game game state
## Used as a helper node, so there can be multiple of scene managers in the same scene

func load_main_menu_scene()->void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)

func load_map_selector_scene()->void:
	_detach_ship()
	get_tree().change_scene_to_file("res://scenes/map_selector.tscn")
	GameManager.set_game_state(GameState.State.MAP_SELECTOR)
	_attach_ship_with_hud()

func load_fly_ship_scene()->void:
	_detach_ship()
	get_tree().change_scene_to_file("res://scenes/fly_ship.tscn")
	GameManager.set_game_state(GameState.State.FLY)
	_attach_ship_with_hud()

func load_build_ship_scene()->void:
	_detach_ship()
	get_tree().change_scene_to_file("res://scenes/build_ship.tscn")
	GameManager.set_game_state(GameState.State.BUILD)
	_attach_ship_without_hud()

## detach the ship from the scene tree, to preserve it, when it is changed
func _detach_ship():
	if GameManager.player_ship != null:
		# detach the ship
		GameManager.player_ship.get_parent_node_3d().remove_child(
			GameManager.player_ship
		)
		GameManager.player_ship.hud = null

## attach the ship to the scene tree
func _attach_ship_with_hud():
	if GameManager.player_ship != null:
		# attach ship
		GameManager.get_tree().root.add_child(GameManager.player_ship)

		# restore hud
		var hud_scene = load("res://prefabs/hud.tscn")
		var hud = hud_scene.instantiate()
		GameManager.get_tree().root.add_child(hud)

## attach the ship to the scene tree
func _attach_ship_without_hud():
	if GameManager.player_ship != null:
		# attach ship
		GameManager.get_tree().root.add_child(GameManager.player_ship)
