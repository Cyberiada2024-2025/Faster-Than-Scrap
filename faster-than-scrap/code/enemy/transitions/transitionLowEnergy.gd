extends baseTransition

@export var low_energy_treshold := 20


func condition() -> void:
	if ship_controller.ship.energy < low_energy_treshold:
		finished.emit(new_state.name)
