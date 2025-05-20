class_name BatteryModule

extends Module

@export var energy: float = 25
@export var energy_regeneration: float = 5


func detach() -> void:
	if ship != null:
		ship.max_energy -= energy
		ship.restore -= energy_regeneration
	super()


func attach() -> void:
	if ship != null:
		ship.max_energy += energy
		ship.restore += energy_regeneration
	super()
