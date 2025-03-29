extends baseTransition

@export var module: Module


func condition() -> void:
	## check if module wasn't destroyed
	if is_instance_valid(module):
		finished.emit(new_state.name)
