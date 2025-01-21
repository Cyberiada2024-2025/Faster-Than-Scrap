class_name PlayerShip

extends Ship

@export var cockpit: Cockpit

## all modules of the ship (to prevent checking the tree hierarchy)
@export var modules: Array[Module] = []

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
