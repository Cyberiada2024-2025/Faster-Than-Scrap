## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
class_name State extends Node

## Emitted when the state finishes and wants to transition to another state.
signal finished(_next_state_path: String, _data: Dictionary)


## Called by the state machine on the engine's main loop tick.
func state_update(_delta: float) -> void:
	pass


## Called by the state machine on the engine's physics update tick.
func state_physics_update(_delta: float) -> void:
	pass


## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	pass


## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
