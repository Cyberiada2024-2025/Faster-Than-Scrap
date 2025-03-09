extends StateNPC
## in euler angles
@export var y_rotation: float = 90
## in seconds
@export var duration: float = 1

var start_rot: Quaternion
var final_rot: Quaternion
var time : float = 0

func enter(_previous_state_path: String, _data := {}) -> void:
	time = 0
	start_rot = Quaternion(ship_controller.basis)
	var diff := Quaternion.from_euler(Vector3(0, deg_to_rad(y_rotation),0))
	final_rot = start_rot * diff

## Called by the state machine on the engine's main loop tick.
func state_update(delta: float) -> void:
	time += delta
	var percentage := time/duration
	if percentage >= 1.0:
		ship_controller.rotation = final_rot.get_euler()
	else:
		ship_controller.rotation += Vector3(0, deg_to_rad(y_rotation),0) * delta / duration

func exit() -> void:
	ship_controller.rotation = final_rot.get_euler()
