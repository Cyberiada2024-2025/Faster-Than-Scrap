extends Node

## Game manager is a singleton!
## It is not supposed to be added to the scene tree!
## It is autoloaded and always available to be called from everywhere!

signal new_game_state

@export var game_state: GameState.State = GameState.State.FLY
@export var death_screen: PackedScene

var player_ship: PlayerShip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	player_ship = preload("res://prefabs/ships/flyable_ship_with_shield.tscn").instantiate()


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
