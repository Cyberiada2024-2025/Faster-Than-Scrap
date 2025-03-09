extends Node

enum MissionType { DEFEND, GET_ITEM, ESCAPE }

var is_finished: bool = false
var about: String = ""
var type: MissionType
var difficulty: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func finish_mission() -> void:
	is_finished = true
