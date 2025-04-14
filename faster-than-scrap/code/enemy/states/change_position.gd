extends StateNPC

## rather for bosses states, or enemies
## in constrained regions.
## State which randomly chosses a new position from
## a set of possible positions

@export var points: Array[Node3D] = []
@export var duration: float = 1

var start_pos: Vector3
var target_node: Node3D
var counter: float = 0
var direction: Vector3


func enter(_previous_state_path: String, _data := {}) -> void:
	counter = 0
	start_pos = ship_controller.global_position
	var copied_points = points.duplicate()
	copied_points.erase(target_node)  # actual position
	target_node = copied_points.pick_random()  # select new position
	direction = target_node.global_position - start_pos
	direction /= duration


## Called by the state machine on the engine's main loop tick.
func state_physics_update(_delta: float) -> void:
	ship_controller.velocity = direction
	ship_controller.move_and_slide()


## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	#ship_controller.global_position = target_node.global_position
	pass
