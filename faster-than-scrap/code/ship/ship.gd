class_name Ship

extends Node3D

var energy: float = 100
## all modules of the ship (to prevent checking the tree hierarchy)
@export var modules: Array[Module] = []
var cockpit: Cockpit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called when module wants to use the ship's energy [member Ship.energy].
## Returns true when it can afford that amount (and reduces the energy accordingly)
## otherwise returns false and doesn't change the energy amount.
func use_energy(amount: float) -> bool:
	if energy<amount:
		return false
	energy -= amount
	_on_energy_change()
	return true

## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	pass

func on_game_change_state(new_state : GameState.state) -> void:
	match new_state:
		GameState.state.FLY:
			_activate_modules()
		GameState.state.PAUSE: 
			_deactivate_modules()
		GameState.state.CUTSCENE: 
			_deactivate_modules()
		GameState.state.BUILD: 
			_deactivate_modules()
		GameState.state.MAIN_MENU: 
			pass

func _deactivate_modules():
	for module in modules:
		module.active = false

func _activate_modules():
	for module in modules:
		module.active = true

func on_destroy() -> void: 
	pass
