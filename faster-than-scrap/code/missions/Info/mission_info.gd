class_name MissionInfo

extends Resource

## Class containg only information about the mission.
## It does not process the progress of a mission.
## Supposed to be used in the map select.

enum Priority{MAIN_QUEST, SIDE_QUEST}

@export var about : String = ""
@export var difficulty : int
@export var priority: Priority = Priority.MAIN_QUEST

var mission: Mission

func start() -> void:
	MissionManager.get_tree().root.add_child.call_deferred(mission)
