class_name QuaternionUtilities


## Returns quaternion [param a] rotated towards quaternion [param b]
## by a given [param angle] (in degrees). [br]
## If [param angle] is greater than the angle between the quaterions, returns [param b].
static func rotate_towards(a: Quaternion, b: Quaternion, angle: float) -> Quaternion:
	var angle_to: float = rad_to_deg(a.angle_to(b))
	print(angle_to)
	if angle_to > angle:
		return a.slerp(b, angle / angle_to)
	else:
		return b
