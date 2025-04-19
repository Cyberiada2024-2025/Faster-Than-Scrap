extends StateNPC

@export_range(0, 1) var lerp_strength: float = 0.95
@export var objects: Array[Node3D] = []

var look_object: Node3D = null


func enter(_previous_state_path: String, _data := {}) -> void:
	target = GameManager.find_closest_ship(ship_controller.ship)


## Called by the state machine on the engine's main loop tick.
func state_physics_update(delta: float) -> void:
	if not is_instance_valid(look_object):
		look_object = _select_random_look_object()

	# calculate rotation offset from look object
	var rotation_offset = 0
	if look_object != null:
		rotation_offset = ship_controller.global_rotation.y - look_object.global_rotation.y

	# calculate target rotation
	var look_direction = self.target.global_position - self.ship_controller.global_position
	var rotation = ship_controller.rotation

	ship_controller.rotation.y = lerp_angle(
		rotation.y, atan2(-look_direction.x, -look_direction.z) + rotation_offset, lerp_strength
	)


func _select_random_look_object() -> Node3D:
	var index: int = 0
	# check if any was deleted
	for object in objects:
		if not is_instance_valid(object):
			objects.remove_at(index)
		index += 1
	# check if empty
	if objects.size() == 0:
		return null
	# select random
	var rng = RandomNumberGenerator.new()
	index = rng.randi_range(0, objects.size() - 1)
	return objects[index]
