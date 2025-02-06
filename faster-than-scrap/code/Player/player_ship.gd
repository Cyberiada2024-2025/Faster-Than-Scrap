class_name PlayerShip

extends Ship

@export var cockpit: Cockpit

## All modules of the ship (to prevent checking the tree hierarchy).
## Mostly used for building phase
@export var modules: Array[Module] = []


func _ready() -> void:
	super()
	GameManager.new_game_state.connect(on_game_change_state)
	GameManager.player_ship = self

func on_game_change_state(new_state : GameState.State) -> void:
	match new_state:
		GameState.State.FLY:
			pass
		GameState.State.PAUSE:
			pass
		GameState.State.CUTSCENE:
			pass
		GameState.State.BUILD:
			pass
		GameState.State.MAIN_MENU:
			pass
