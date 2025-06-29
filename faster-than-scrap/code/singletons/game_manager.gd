extends Node

## Game manager is a singleton!
## It is not supposed to be added to the scene tree!
## It is autoloaded and always available to be called from everywhere!

signal new_game_state(new_state: GameState.State)
signal game_reset

@export var game_state: GameState.State = GameState.State.MAIN_MENU
@export var death_screen: PackedScene

var player_ship: PlayerShip
var ships: Array[Ship] = []

var game_over: bool = false

# Called when the node enters the scene tree for the first time.


func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func on_scene_exit() -> void:
	ships = []


func reset() -> void:
	game_reset.emit()

	game_over = false
	ships = []

	player_ship.queue_free()
	player_ship = null


func set_game_state(new_state: GameState.State) -> void:
	game_state = new_state
	new_game_state.emit(new_state)
	# future logic for changing state
	match new_state:
		GameState.State.FLY:
			turn_player_modules(true)
		GameState.State.PAUSE:
			turn_player_modules(false)
		GameState.State.BUILD:
			turn_player_modules(false)
		GameState.State.MAIN_MENU:
			#turn_player_modules(true)
			pass


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
	game_over = true
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
		if TeamManager.hate(ship.team, s.team):
			if s != ship && (s.global_position - position).length_squared() < distance_sqr:
				distance_sqr = (s.global_position - position).length_squared()
				closest = s
	return closest


func find_all_enemies(team: TeamManager.Team) -> Array[Ship]:
	var enemies: Array[Ship] = []
	for ship in ships:
		if TeamManager.hate(team, ship.team):
			enemies.append(ship)
	return enemies
