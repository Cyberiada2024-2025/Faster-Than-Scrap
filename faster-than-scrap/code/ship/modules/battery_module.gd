class_name BatteryModule

extends Module

@export var energy: float = 25
@export var energy_regeneration: float = 5


func on_detach() -> void:
	ship.max_energy -= energy
	ship.restore -= energy_regeneration
	super()


func on_attach() -> void:
	ship.max_energy += energy
	ship.restore += energy_regeneration
	super()
