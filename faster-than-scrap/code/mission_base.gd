extends Node

enum MissionType { DEFEND, GET_ITEM, ESCAPE }

var is_finished : bool = false
var about : String = ""
var type : MissionType
var difficulty : int

#var reward : 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
