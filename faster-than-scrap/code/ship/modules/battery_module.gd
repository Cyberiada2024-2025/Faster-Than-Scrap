class_name BatteryModule

extends Module

@export var energy: float = 25
@export var energy_regeneration: float = 5

var _previous_ship_reference: Ship = null


func set_ship_reference(ship_ref: Ship) -> void:
	_previous_ship_reference = ship
	super(ship_ref)


func detach() -> void:
	if ship != null:
		ship.max_energy -= energy
		ship.restore -= energy_regeneration
	super()


func attach() -> void:
	if ship != null and ship != _previous_ship_reference:
		ship.max_energy += energy
		ship.restore += energy_regeneration
	super()
