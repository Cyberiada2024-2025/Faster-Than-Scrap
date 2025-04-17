extends StateNPC

@export_range(0, 1) var lerp_strength: float = 0.95


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)


## Called by the state machine on the engine's main loop tick.
func state_physics_update(delta: float) -> void:
	# calculat target rotation
	var look_direction = self.target.global_position - self.ship_controller.global_position
	var rotation = ship_controller.rotation

	ship_controller.rotation.y = lerp_angle(
		rotation.y, atan2(-look_direction.x, -look_direction.z), lerp_strength
	)
