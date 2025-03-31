class_name Missile

extends Projectile

## Curve representing the missile's turn rate in time. (degrees per second)
## [code]X = 1[/code] on the curve represents the end of the projectile's lifetime.
## Useful for example to make the missile not turn immediately after spawning.
@export var turn_rate: Curve

## Turn rate from the [param turn_rate] curve will be multiplied by this number.
## This makes it easier to quickly adjust the missile's turn rate.
@export var turn_rate_multiplier: float = 1

## The object this missile follows
var target: Node3D


func _process(delta: float) -> void:
	super(delta)
	_process_rotation(delta)
	if target == null or not target.is_inside_tree():
		target = _find_target()


func _find_target() -> Node3D:
	# TODO: use actual enemies once they are implemented
	var enemies = get_tree().get_nodes_in_group("affected by vortex")
	if enemies.size() == 0:
		return null

	return enemies.pick_random()


func _process_rotation(delta: float) -> void:
	if not target:
		return

	var turn_speed = turn_rate.sample_baked(_current_lifetime / lifetime)
	turn_speed *= turn_rate_multiplier

	var original_quaternion: Quaternion = quaternion
	look_at(target.position)
	var target_quaternion: Quaternion = quaternion

	quaternion = QuaternionUtilities.rotate_towards(
		original_quaternion, target_quaternion, turn_speed * delta
	)
