class_name Mission

extends Resource

## Base class for mission which can be added/displayed in the mission selector.
## When the game is loaded (start of the fly ship phase) the mission 
##should be initialized, by calling setup() 

enum MissionType { DEFEND, GET_ITEM, ESCAPE }
enum MissionState { IN_PROGRESS, FINISHED, FAILED }

var state: MissionState = MissionState.IN_PROGRESS
var about : String = ""
var type : MissionType
var difficulty : int

func _init(about: String, type: MissionType, difficulty: int):
	self.about = about
	self.type = type
	self.difficulty = difficulty

func setup() -> void:
	# add self to manager
	MissionManager.missions.append(self)

func check_finish() -> void:
	pass

## returns whether the missions ended.
## Either by success or failure
func _ended() -> bool :
	return state == MissionState.FINISHED or state == MissionState.FAILED
