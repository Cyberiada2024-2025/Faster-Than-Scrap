class_name PlayerShip

extends Ship

@export var cockpit: Cockpit
@export var energy_bar: ResourceBar

## All modules of the ship (to prevent checking the tree hierarchy).
## Mostly used for building phase
@export var modules: Array[Module] = []


func _ready() -> void:
	super()
	GameManager.new_game_state.connect(on_game_change_state)
	GameManager.player_ship = self
	energy_bar._on_max_change(max_energy)
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
	energy_bar._change_value(energy)
	
func use_energy(amount: float) -> bool:
	if(energy<amount):
		energy_bar._on_warning()
	return super(amount)
