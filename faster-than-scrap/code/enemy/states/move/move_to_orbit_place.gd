extends StateNPC

## Will move the npc to a random point on a circle edge around the target.
##        |angle
##    \   |diff/
##     \  |  /  radius
##      \ | /
##       \|/
##        . target
##

@export var orbit_radius: float = 30
@export_range(0, 1) var lerp_strength: float = 0.4
@export_range(0, 180) var max_angle_diff: float = 30

var destination: Vector3


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)
	var direction_from_target = (
		self.ship_controller.ship.global_position - self.target.global_position
	)
	direction_from_target.y = 0
	direction_from_target = direction_from_target.normalized()

	var rng = RandomNumberGenerator.new()
	var rotation = deg_to_rad(rng.randf_range(-max_angle_diff, max_angle_diff))
	direction_from_target = direction_from_target.rotated(Vector3.UP, rotation)

	destination = self.target.global_position + direction_from_target * orbit_radius
	destination.y = 0


## Called by the state machine on the engine's main loop tick.
func state_physics_update(_delta: float) -> void:
	super(_delta)
	var direction = destination - self.ship_controller.ship.global_position
	direction.y = 0

	ship_controller.linear_velocity = direction * lerp_strength
