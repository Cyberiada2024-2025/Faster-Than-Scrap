extends baseTransition

@export var low_energy_treshold := 20


func condition() -> void:
	if controlled_ship.energy < low_energy_treshold:
		finished.emit(new_state.name)
