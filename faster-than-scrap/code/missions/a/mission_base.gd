class_name Mission

extends Node

## Base class for mission which can be added/displayed in the mission selector.
## When the game is loaded (start of the fly ship phase) the mission
##should be initialized, by calling setup()

enum MissionState { IN_PROGRESS, FINISHED, FAILED }

signal finished

var state: MissionState = MissionState.IN_PROGRESS


func _ready() -> void:
	setup()

func setup() -> void:
	# add self to manager
	MissionManager.missions.append(self)

func _process(delta: float) -> void:
	pass

## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool :
	return state == MissionState.FINISHED or state == MissionState.FAILED
