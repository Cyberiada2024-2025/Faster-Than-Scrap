extends StateNPC
## in euler angles
@export var y_rotation_speed: float = 90


## Called by the state machine on the engine's main loop tick.
func state_physics_update(delta: float) -> void:
	ship_controller.angular_velocity = Vector3(0, deg_to_rad(y_rotation_speed), 0)
