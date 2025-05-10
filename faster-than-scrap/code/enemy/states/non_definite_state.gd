@tool
class_name NonDefiniteStateNPC
extends StateNPC

## Base class to work with [TransitionOnStateFinish] class.
## The NonDefiniteState class should be used, when something should happen
## right after the state has finished it's action, but it's hard determine from
## transition when does it happen.

@export var _transition_to_call: TransitionOnStateFinish


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if _transition_to_call == null or not is_instance_valid(_transition_to_call):
		warnings.append("TransitionToCall not set")
	return warnings


## function to end the state
func _finish_state() -> void:
	_transition_to_call.relay()
