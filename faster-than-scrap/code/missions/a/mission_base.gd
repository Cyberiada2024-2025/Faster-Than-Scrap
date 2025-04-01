class_name Mission

extends Node

## Base class for mission which will check its completion in game
## When created it will automaticaly set itself up by calling [setup()]

signal finished(mission: Mission)

enum MissionState { IN_PROGRESS, FINISHED, FAILED }

var state: MissionState = MissionState.IN_PROGRESS


func _ready() -> void:
	setup()


func setup() -> void:
	# add self to manager
	MissionManager.add_mission(self)


func _process(_delta: float) -> void:
	pass


## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool:
	return state == MissionState.FINISHED or state == MissionState.FAILED


func create_label(text: String) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = 180
	label.position = Vector3(0, 0, 2)
	label.rotation_degrees = Vector3(270, 0, 0)
	return label
