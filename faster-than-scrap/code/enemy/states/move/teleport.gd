extends NonDefiniteStateNPC

## Will teleport the npc to a random point on a circle edge around the target.
##        |angle
##    \   |diff/
##     \  |  /  radius
##      \ | /
##       \|/
##        . target
##

@export var teleport_radius: float = 30
@export_range(0, 180) var max_angle_diff: float = 30
@export var scale_animation_time: float = 1
@export var node_to_scale: Node3D

var destination: Vector3
var time_accumulator: float


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)
	var direction_from_target = (
		(self.ship_controller.ship.global_position - self.target.global_position).normalized()
	)
	var rng = RandomNumberGenerator.new()
	var rotation = deg_to_rad(rng.randf_range(-max_angle_diff, max_angle_diff))
	direction_from_target = direction_from_target.rotated(Vector3.UP, rotation)

	destination = self.target.global_position + direction_from_target * teleport_radius
	time_accumulator = 0

	# shrink
	var tween = get_tree().create_tween()
	tween.tween_property(node_to_scale, "scale", Vector3.ZERO, scale_animation_time).set_trans(
		Tween.TRANS_SINE
	)
	await tween.finished

	# teleport
	ship_controller.global_position = destination

	# grow
	tween = get_tree().create_tween()
	tween.tween_property(node_to_scale, "scale", Vector3.ONE, scale_animation_time).set_trans(
		Tween.TRANS_SINE
	)
	await tween.finished

	_finish_state()
