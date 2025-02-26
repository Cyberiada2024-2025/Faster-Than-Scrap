extends baseTransition

@export var highEnergyTreshold := 70

func condition() -> void:
	if controlledShip.energy >= highEnergyTreshold:
		finished.emit(newState.name)
