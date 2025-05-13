class_name BatteryModule

extends Module

@export var energy: float = 25


func _on_destroy() -> void:
	ship.max_energy -= energy
	super()


func set_ship_reference(ship_ref: Ship) -> void:
	if ship_ref != ship:
		if ship != null:
			ship.max_energy -= energy
		if ship_ref != null:
			ship_ref.max_energy += energy

	super(ship_ref)
