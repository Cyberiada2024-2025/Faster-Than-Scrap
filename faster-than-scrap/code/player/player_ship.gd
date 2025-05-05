class_name PlayerShip

extends Ship

## Extension of Ship class.
## Supposed to be used only by player.

signal energy_change
signal energy_max_change
signal energy_warning

@export var cockpit: Cockpit

## All modules of the ship (to prevent checking the tree hierarchy).
## Mostly used for building phase
@export var modules: Array[Module] = []
var current_fuel: int = 3

var _saved_position: Vector3 = Vector3.ZERO
var _saved_rotation: Vector3 = Vector3.ZERO


func _enter_tree() -> void:
	GameManager.player_ship = self


func _ready() -> void:
	super()
	GameManager.new_game_state.connect(on_game_change_state)
	energy_max_change.emit(max_energy)
	_on_energy_change()


func on_game_change_state(new_state: GameState.State) -> void:
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


func save_position():
	_saved_position = position


func save_rotation():
	_saved_rotation = rotation


func get_saved_position():
	return _saved_position


func get_saved_rotation():
	return _saved_rotation


## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	super()
	energy_change.emit(energy)


func use_energy(amount: float) -> bool:
	if energy < amount:
		energy_warning.emit()
	return super(amount)


func on_destroy() -> void:
	super()
	GameManager.show_death_screen()
