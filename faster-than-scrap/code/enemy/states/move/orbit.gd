extends StateNPC

@export var orbit_radius: float = 30
@export var lerp_strength: float = 0.4
@export var orbit_angular_speed: float = 30

var direction_from_target: Vector3
var orbit_radial_speed: float


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)
	direction_from_target = self.ship_controller.ship.global_position - self.target.global_position
	orbit_radial_speed = deg_to_rad(orbit_angular_speed)


## Called by the state machine on the engine's main loop tick.
func state_physics_update(delta: float) -> void:
	# rotate direction vector
	direction_from_target = direction_from_target.rotated(Vector3.UP, orbit_radial_speed * delta)
	direction_from_target = direction_from_target.normalized()

	# calculate direct pos
	var direct_pos = self.target.global_position + direction_from_target * orbit_radius

	var direction = direct_pos - self.ship_controller.ship.global_position
	ship_controller.velocity = direction * lerp_strength
	ship_controller.move_and_slide()
