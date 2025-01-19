class_name PlayerShip

extends Ship

@export var cockpit: Cockpit

## all modules of the ship (to prevent checking the tree hierarchy)
@export var modules: Array[Module] = []

func on_game_change_state(new_state : GameState.State) -> void:
	match new_state:
		GameState.State.FLY:
			_activate_modules()
		GameState.State.PAUSE:
			_deactivate_modules()
		GameState.State.CUTSCENE:
			_deactivate_modules()
		GameState.State.BUILD:
			_deactivate_modules()
		GameState.State.MAIN_MENU:
			pass

func _deactivate_modules():
	for module in modules:
		module.active = false

func _activate_modules():
	for module in modules:
		module.active = true
