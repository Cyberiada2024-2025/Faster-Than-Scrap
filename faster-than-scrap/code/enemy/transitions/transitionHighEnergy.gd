extends baseTransition

@export var high_energy_treshold := 70


func condition() -> void:
	if controlled_ship.energy >= high_energy_treshold:
		finished.emit(new_state.name)
