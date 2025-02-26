extends baseTransition

@export var rangeTreshold := 50

func condition() -> void:
	var vector_to_target = target.global_position - controlledShip.global_position
	if vector_to_target.length() > rangeTreshold: 
		finished.emit(newState.name)
