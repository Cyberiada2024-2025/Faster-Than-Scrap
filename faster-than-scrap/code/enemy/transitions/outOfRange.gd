extends baseTransition

@export var range_treshold := 50


func condition() -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)
	# code for no ship found
	if target == ship_controller.ship:
		return
	var vector_to_target = target.global_position - ship_controller.ship.global_position
	if vector_to_target.length() > range_treshold:
		finished.emit(new_state.name)
