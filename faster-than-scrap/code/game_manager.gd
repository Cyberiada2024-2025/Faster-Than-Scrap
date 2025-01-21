class_name GameManager

extends Node

signal new_game_state

## root for the game tree (not the root of the scene tree)
## game manager is next to that, so it can turn it off using
## builtin .paused flag and allow the ui and game manager work
@export var game_root : Node3D
@export var game_state :GameState.State = GameState.State.FLY
@export var ship: PlayerShip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ship == null:
		printerr("Game manager has player ship as nil")
	else:
		# connect signal to ship
		# connecting should be moved elsewhere, when the main menu
		# is implemented
		new_game_state.connect(ship.on_game_change_state)


func _set_game_state(new_state: GameState.State) -> void:
	game_state=new_state
	ship.on_game_change_state(new_state)
	new_game_state.emit(new_state)
	# future logic for changing state
	match new_state:
		GameState.State.FLY:
			_unpause_entities()
		GameState.State.PAUSE:
			_pause_entities()
		GameState.State.CUTSCENE:
			_unpause_entities()
		GameState.State.BUILD:
			_pause_entities()
		GameState.State.MAIN_MENU:
			_unpause_entities()

func _pause_entities():
	game_root.get_tree().paused = true

func _unpause_entities():
	game_root.get_tree().paused = false
