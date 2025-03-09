extends Node

## Game manager is a singleton!
## It is not supposed to be added to the scene tree!
## It is autoloaded and always available to be called from everywhere!

signal new_game_state

@export var game_state: GameState.State = GameState.State.FLY
@export var player_ship: PlayerShip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func set_game_state(new_state: GameState.State) -> void:
	game_state = new_state
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
	get_tree().paused = true


func _unpause_entities():
	get_tree().paused = false
