extends Node

## Game manager is a singleton!
## It is not supposed to be added to the scene tree!
## It is autoloaded and always available to be called from everywhere!

signal new_game_state

@export var game_state: GameState.State = GameState.State.FLY
@export var death_screen: PackedScene

var player_ship: PlayerShip
var ships: Array[Ship] = []


# Called when the node enters the scene tree for the first time.


func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	player_ship = preload("res://prefabs/ships/flyable_ship.tscn").instantiate()


func on_scene_exit() -> void:
	ships = []
	if game_state==GameState.State.BUILD:
		InventoryManager.change_inventory()


func set_game_state(new_state: GameState.State) -> void:
	game_state = new_state
	new_game_state.emit(new_state)
	# future logic for changing state
	match new_state:
		GameState.State.FLY:
			turn_player_modules(true)
		GameState.State.PAUSE:
			turn_player_modules(false)
		GameState.State.CUTSCENE:
			turn_player_modules(true)
		GameState.State.BUILD:
			turn_player_modules(false)
		GameState.State.MAIN_MENU:
			turn_player_modules(true)


func _pause_entities():
	get_tree().paused = true


func _unpause_entities():
	get_tree().paused = false


func turn_player_modules(on: bool):
	if GameManager.player_ship != null:
		var modules = GameManager.player_ship.find_children("*", "Module", false, false)
		for module in modules:
			if on:
				module.activate()
			else:
				module.deactivate()


func show_death_screen():
	var death_screen_scene = death_screen.instantiate()
	GameManager.get_tree().current_scene.add_child(death_screen_scene)


func _on_ship_born(ship: Ship):
	ships.append(ship)
	ship.destroyed.connect(_on_ship_death)


func _on_ship_death(ship: Ship):
	ships.erase(ship)


## return the closest ship
## if no ship is found returns input ship
func find_closest_ship(ship: Ship) -> Ship:
	var closest: Ship = ship
	var position: Vector3 = ship.global_position
	var distance_sqr: float = INF
	for s in ships:
		if TeamManager.hate(ship, s):
			if s != ship && (s.global_position - position).length_squared() < distance_sqr:
				distance_sqr = (s.global_position - position).length_squared()
				closest = s
	return closest
