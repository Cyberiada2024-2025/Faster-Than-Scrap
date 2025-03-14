class_name Ship

extends Node3D

## Base class for player and enemy

@export var energy: float = 100

@export var max_energy: float = 100

@export var restore: float = 10


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	energy += restore * delta

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

func on_destroy() -> void:
	pass
