extends StateNPC

@export_range(0, 1) var lerp_strength: float = 0.95
@export var objects: Array[Node3D] = []

var look_object: Node3D = null
var rotation_offset: float = 0


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)
	look_object = null


## Called by the state machine on the engine's main loop tick.
func state_physics_update(_delta: float) -> void:
	if not is_instance_valid(look_object):
		_select_look_object()

	# calculate target rotation
	var look_direction = self.target.global_position - self.ship_controller.global_position
	look_direction.y = 0
	var rotation = ship_controller.rotation  # already global

	var target_rot = atan2(-look_direction.x, -look_direction.z) + rotation_offset
	ship_controller.rotation.y = lerp_angle(rotation.y, target_rot, lerp_strength)


## select the object having the smallest angle resulted from the ship rotation
func _select_look_object() -> void:
	var index: int = 0
	var smallest_angle: float = INF

	# check if any was deleted
	for object in objects:
		if not is_instance_valid(object):
			objects.remove_at(index)
		# check angle between forward and direction to target
		var direction_to_target = self.target.global_position - object.global_position
		direction_to_target.y = 0
		var forward = -object.global_transform.basis.z  # in godot forward is [0,0,-1]
		var angle = direction_to_target.angle_to(forward)

		if angle < smallest_angle:
			smallest_angle = angle
			look_object = object
		index += 1

	# check if empty
	if objects.size() == 0:
		rotation_offset = 0
		look_object = null
		return

	# calculate rotation offset from look object
	if look_object != null:
		_set_rotation_offset(look_object)


func _set_rotation_offset(look_object: Node3D) -> void:
	var ship_forward = -ship_controller.global_transform.basis.z  # in godot forward is [0,0,-1]
	var look_foward = -look_object.global_transform.basis.z  # in godot forward is [0,0,-1]

	# cast to 2d, to get signed angle_to call
	var ship_forward_2d = Vector2(ship_forward.x, ship_forward.z)
	var look_foward_2d = Vector2(look_foward.x, look_foward.z)

	rotation_offset = ship_forward_2d.angle_to(look_foward_2d)
