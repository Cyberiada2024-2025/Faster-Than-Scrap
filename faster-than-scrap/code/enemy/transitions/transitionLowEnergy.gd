extends baseTransition

@export var lowEnergyTreshold := 20

func condition() -> void:
	if controlledShip.energy < lowEnergyTreshold:
		finished.emit(newState.name)
	
