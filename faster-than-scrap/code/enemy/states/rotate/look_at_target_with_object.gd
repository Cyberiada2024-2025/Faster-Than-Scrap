extends StateNPC

@export_range(0, 1) var lerp_strength: float = 0.95
@export var objects: Array[Node3D] = []

var look_object: Node3D = null
var rotation_offset: float = 0


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)


## Called by the state machine on the engine's main loop tick.
func state_physics_update(delta: float) -> void:
	if not is_instance_valid(look_object):
		look_object = _select_look_object()

	# calculate target rotation
	var look_direction = self.target.global_position - self.ship_controller.global_position
	var rotation = ship_controller.rotation  # already global

	var target_rot = atan2(-look_direction.x, -look_direction.z) + rotation_offset
	ship_controller.rotation.y = lerp_angle(rotation.y, target_rot, lerp_strength)


## select the object having the smallest angle resulted from the ship rotation
func _select_look_object() -> Node3D:
	var index: int = 0
	var smallest_angle: float = INF
	var best_index: int = 0

	# check if any was deleted
	for object in objects:
		if not is_instance_valid(object):
			objects.remove_at(index)
		# check angle between forward and direction to target
		var direction_to_target = self.target.global_position - object.global_position
		var forward = -object.global_transform.basis.z  # in godot forward is [0,0,-1]
		var angle = direction_to_target.angle_to(forward)

		if angle < smallest_angle:
			smallest_angle = angle
			best_index = index
		index += 1

	# check if empty
	if objects.size() == 0:
		return null

	# calculate rotation offset from look object
	var rotation_offset = 0
	if look_object != null:
		_set_rotation_offset(look_object)

	return objects[best_index]


func _set_rotation_offset(look_object: Node3D) -> void:
	var ship_forward = -ship_controller.global_transform.basis.z  # in godot forward is [0,0,-1]
	var look_foward = -look_object.global_transform.basis.z  # in godot forward is [0,0,-1]
	rotation_offset = ship_forward.angle_to(look_foward)
