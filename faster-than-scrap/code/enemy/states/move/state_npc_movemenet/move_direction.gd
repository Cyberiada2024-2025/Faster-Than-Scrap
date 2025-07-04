class_name MovementDirection extends StateNPC

@export var acceleration: Vector3 = Vector3(0, -1, 0)

var direction: Vector3


func enter(_previous_state_path: String, _data := {}) -> void:
	direction = Vector3(0, 0, 0)


## Called by the state machine on the engine's main loop tick.
func state_physics_update(_delta: float) -> void:
	super(_delta)
	ship_controller.linear_velocity = direction
	direction += _delta * acceleration
