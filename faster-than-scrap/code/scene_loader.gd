class_name SceneLoader

extends Node

## object which loads new scene and informs the game manager
## of the game game state
## Used as a helper node, so there can be multiple of scene managers in the same scene

var default_ship_prefab = preload("res://prefabs/ships/flyable_ship.tscn")


func load_main_menu_scene() -> void:
	GameManager.on_scene_exit()

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)


func _reset_game() -> void:
	MapGenerator.reset()
	MapSaver.reset()
	CutsceneManager.reset_cutscenes()
	GameManager.reset()


#region tutorials


func load_movement_tutorial() -> void:
	_reset_game()

	HudSpawner.spawn_hud = true
	GameManager.set_game_state(GameState.State.FLY)
	get_tree().change_scene_to_file("res://scenes/tutorials/basic_movement_tutorial.tscn")


func load_build_tutorial() -> void:
	load_build_ship_scene(true)


#endregion


func load_map_selector_scene() -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/map_selector.tscn")
	GameManager.set_game_state(GameState.State.MAP_SELECTOR)


func load_fly_ship_scene(
	scene_to_load: PackedScene = null,
	pos: Vector3 = Vector3.ZERO,
	rot: Vector3 = Vector3.ZERO,
	use_saved_pos_rot: bool = true
) -> void:
	var attached_fly_scene: bool = false

	if GameManager.game_state == GameState.State.BUILD:
		InventoryManager.save_inventory()

	_detach_ship()
	if scene_to_load != null:
		GameManager.on_scene_exit()
		get_tree().change_scene_to_file(scene_to_load.resource_path)
	else:
		if GameManager.game_state == GameState.State.BUILD:
			attached_fly_scene = MapGenerator.swap_saved_and_current_scene()
		if not attached_fly_scene:
			GameManager.on_scene_exit()
			GameManager.get_tree().change_scene_to_file("res://scenes/levels/start_level.tscn")
			use_saved_pos_rot = false

	GameManager.set_game_state(GameState.State.FLY)

	if use_saved_pos_rot and GameManager.player_ship != null:
		pos = GameManager.player_ship.get_saved_position()
		rot = GameManager.player_ship.get_saved_rotation()

	_attach_ship_with_hud.call_deferred(pos, rot)

	_set_vortex_preserve(false)


func load_boss_scene(pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> void:
	_detach_ship()
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/boss_scene.tscn")
	GameManager.set_game_state(GameState.State.FLY)
	_attach_ship_with_hud.call_deferred(pos, rot)


func load_build_ship_scene(tutorial_version = false) -> void:
	_set_vortex_preserve(true)
	GameManager.player_ship.save_position()
	GameManager.player_ship.save_rotation()
	_detach_ship()

	var attached_build_scene: bool = false
	if GameManager.game_state == GameState.State.FLY:
		attached_build_scene = MapGenerator.swap_saved_and_current_scene()

	if not attached_build_scene:
		if tutorial_version:
			GameManager.get_tree().change_scene_to_file(
				"res://scenes/tutorials/build_ship_tutorial.tscn"
			)
		else:
			GameManager.get_tree().change_scene_to_file("res://scenes/build_ship.tscn")

	GameManager.set_game_state(GameState.State.BUILD)
	_attach_ship_with_hud.call_deferred()


func load_credits_scene() -> void:
	GameManager.on_scene_exit()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	GameManager.set_game_state(GameState.State.MAIN_MENU)


func load_lore_scene() -> void:
	_detach_ship()
	get_tree().change_scene_to_file("res://scenes/lore_start.tscn")
	GameManager.set_game_state(GameState.State.CUTSCENE)


## detach the ship from the scene tree, to preserve it, when it is changed
func _detach_ship():
	if GameManager.player_ship == null:
		return

	if GameManager.player_ship.get_parent() == null:
		return

	# detach the ship
	GameManager.player_ship.get_parent().remove_child(GameManager.player_ship)

	# hud will be destroyed automaticaly


## attach the ship to the scene tree
func _attach_ship_with_hud(pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO):
	if GameManager.player_ship == null:
		GameManager.player_ship = default_ship_prefab.instantiate()
	# attach ship
	GameManager.get_tree().root.add_child(GameManager.player_ship)
	GameManager.ships.push_back(GameManager.player_ship)

	# zero velocity
	GameManager.player_ship.linear_velocity = Vector3.ZERO
	GameManager.player_ship.angular_velocity = Vector3.ZERO

	# set pos and rot
	GameManager.player_ship.position = pos
	GameManager.player_ship.rotation = rot

	HudSpawner.spawn_hud = true


## attach the ship to the scene tree
func _attach_ship_without_hud():
	if GameManager.player_ship == null:
		GameManager.player_ship = default_ship_prefab.instantiate()
	# attach ship
	GameManager.get_tree().root.add_child(GameManager.player_ship)
	GameManager.ships.push_back(GameManager.player_ship)

	# zero velocity
	GameManager.player_ship.linear_velocity = Vector3.ZERO
	GameManager.player_ship.angular_velocity = Vector3.ZERO


## See [member SpaceVortex.preserve_target] for reference
func _set_vortex_preserve(preserve: bool) -> void:
	if SpaceVortex.instance != null:
		SpaceVortex.instance.preserve_target = preserve
