class_name movementState extends StateNPC

## width of band around circle defined by target and min_range_to_player
@export var dead_zone: float = 2;
## in dead_zone do we stop in place [false] or keep circling [true]
@export var circle_target: bool = false

func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - ship_controller.global_position
	var direction = vector_to_target.normalized()
	var target_basis: Basis

	# frame dependent
	# https://forum.godotengine.org/t/slowly-interpolate-look-at-function-for-my-enemy/100750/3
	# we try to keep desired distance, by moving to or away from target
	if vector_to_target.length() > min_range_to_player:
		target_basis = Basis.looking_at(direction)
	else:
		target_basis = Basis.looking_at(-1 * direction)

	# if we are outside of dead zone proceed normally - rotate and move
	if abs(vector_to_target.length() - min_range_to_player) > dead_zone/2:
		ship_controller.basis = ship_controller.basis.slerp(target_basis, ship_controller.rotation_speed)
		ship_controller.velocity = ship_controller.speed * ship_controller.basis.z * -1
	# if we are in dead zone and not circling, then stop moving, and rotate towards target
	elif !circle_target:
		ship_controller.velocity = ship_controller.velocity.lerp(Vector3.ZERO, 0.04)
		target_basis = Basis.looking_at(direction)
		ship_controller.basis = ship_controller.basis.slerp(target_basis, ship_controller.rotation_speed)
	# if are in dead zone and circling, then move forward, but do not rotate
	# we will leave the dead zone, return to it and again move in a line
	# not bad illusion of flying in a circle around target
	else:
		ship_controller.velocity = ship_controller.speed * ship_controller.basis.z * -1
	ship_controller.move_and_slide()
