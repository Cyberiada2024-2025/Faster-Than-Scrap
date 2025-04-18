class_name SceneLoader

extends Node

## object which loads new scene and informs the game manager
## of the game game state
## Used as a helper node, so there can be multiple of scene managers in the same scene

var default_ship_prefab = preload("res://prefabs/ships/flyable_ship_with_shield.tscn")


func load_main_menu_scene() -> void:
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)


func load_map_selector_scene() -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/map_selector.tscn")
	GameManager.set_game_state(GameState.State.MAP_SELECTOR)


func load_fly_ship_scene(pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/fly_ship.tscn")
	GameManager.set_game_state(GameState.State.FLY)
	_attach_ship_with_hud.call_deferred(pos, rot)


func load_boss_scene(pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/boss_scene.tscn")
	GameManager.set_game_state(GameState.State.FLY)
	_attach_ship_with_hud.call_deferred(pos, rot)


func load_build_ship_scene() -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/build_ship.tscn")
	GameManager.set_game_state(GameState.State.BUILD)
	_attach_ship_with_hud.call_deferred()


func load_credits_scene() -> void:
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)
	MapGenerator.reset()


## detach the ship from the scene tree, to preserve it, when it is changed
func _detach_ship():
	if GameManager.player_ship == null:
		return

	if GameManager.player_ship.get_parent() == null:
		return

	# detach the ship
	GameManager.player_ship.get_parent().remove_child(GameManager.player_ship)

	## hud will be destroyed automaticaly


## attach the ship to the scene tree
func _attach_ship_with_hud(pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO):
	if GameManager.player_ship == null:
		GameManager.player_ship = (default_ship_prefab.instantiate())
	# attach ship
	GameManager.get_tree().root.add_child(GameManager.player_ship)
	GameManager.ships.push_back(GameManager.player_ship)

	# zero velocity
	GameManager.player_ship.linear_velocity = Vector3.ZERO
	GameManager.player_ship.angular_velocity = Vector3.ZERO

	# set pos and rot
	GameManager.player_ship.position = pos
	GameManager.player_ship.rotation = rot


## attach the ship to the scene tree
func _attach_ship_without_hud():
	if GameManager.player_ship == null:
		GameManager.player_ship = (default_ship_prefab.instantiate())
	# attach ship
	GameManager.get_tree().root.add_child(GameManager.player_ship)
	GameManager.ships.push_back(GameManager.player_ship)

	# zero velocity
	GameManager.player_ship.linear_velocity = Vector3.ZERO
	GameManager.player_ship.angular_velocity = Vector3.ZERO
