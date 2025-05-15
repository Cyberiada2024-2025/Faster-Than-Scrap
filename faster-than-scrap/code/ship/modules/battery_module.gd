class_name BatteryModule

extends Module

@export var energy: float = 25


func detach() -> void:
	if ship != null:
		ship.max_energy -= energy
	super()


func attach() -> void:
	if ship != null:
		ship.max_energy += energy
	super()
