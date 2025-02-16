class_name PlayerShip

extends Ship

signal energy_change
signal energy_max_change
signal energy_warning

@export var cockpit: Cockpit
@export var hud: Hud

## All modules of the ship (to prevent checking the tree hierarchy).
## Mostly used for building phase
@export var modules: Array[Module] = []

func _enter_tree() -> void:
	GameManager.player_ship = self

func _ready() -> void:
	super()
	GameManager.new_game_state.connect(on_game_change_state)
	energy_max_change.emit(max_energy)
	_on_energy_change()

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

## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	super()
	energy_change.emit(energy)

func use_energy(amount: float) -> bool:
	if(energy<amount):
		energy_warning.emit()
	return super(amount)
