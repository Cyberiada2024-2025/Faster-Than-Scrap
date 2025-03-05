extends baseTransition

@export var high_energy_treshold := 70


func condition() -> void:
	if ship_controller.ship.energy >= high_energy_treshold:
		finished.emit(new_state.name)
