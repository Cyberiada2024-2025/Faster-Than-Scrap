class_name Mission

extends Node

## Base class for mission which will check its completion in game
## When created it will automaticaly set itself up by calling [setup()]

signal finished

enum MissionState { IN_PROGRESS, FINISHED, FAILED }

var state: MissionState = MissionState.IN_PROGRESS


func _ready() -> void:
	setup()

func setup() -> void:
	# add self to manager
	MissionManager.missions.append(self)

func _process(_delta: float) -> void:
	pass

## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool :
	return state == MissionState.FINISHED or state == MissionState.FAILED
