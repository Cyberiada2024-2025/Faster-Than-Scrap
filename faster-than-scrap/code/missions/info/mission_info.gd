class_name MissionInfo

extends Resource

## Class containg only information about the mission.
## It does not process the progress of a mission.
## Supposed to be used in the map select.

@export var about: String = ""
@export var difficulty: int


func get_node_description() -> String:
	return about
