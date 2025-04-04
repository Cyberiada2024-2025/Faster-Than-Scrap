extends StateNPC

var child_states: Array[State] = []

func _ready() -> void:
	for state: State in find_children("*", "State"):
		child_states.append(state)
	super()

## Called by the state machine on the engine's main loop tick.
func state_update(delta: float) -> void:
	for state in child_states:
		state.state_update(delta)

## Called by the state machine on the engine's physics update tick.
func state_physics_update(delta: float) -> void:
	for state in child_states:
		state.state_physics_update(delta)

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	for state in child_states:
		state.enter(_previous_state_path, _data)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	for state in child_states:
		state.exit()
