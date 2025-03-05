extends baseTransition

@export var range_treshold := 50


func condition() -> void:
	var vector_to_target = target.global_position - controlled_ship.global_position
	if vector_to_target.length() > range_treshold:
		finished.emit(new_state.name)
