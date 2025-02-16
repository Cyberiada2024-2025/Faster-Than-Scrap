class_name MissionTimedDefend

extends Mission

var defendable: Node3D
@export var defendable_position: Vector3=Vector3.ZERO
@export var time_to_defend: float = 60
var failed = false


func setup() -> void:
	super()

	# create defendable object
	# TODO swap to instantiating the defendable asset f.e.: ally ship
	defendable = MeshInstance3D.new()
	defendable.mesh = BoxMesh.new() 
	MissionManager.add_child(defendable)

	# add timer
	var timer := Timer.new()
	# add to tree
	timer.timeout.connect(success)
	MissionManager.add_child(timer)
	timer.start(time_to_defend)

	# position it
	defendable.global_position = defendable_position

func check_finish() -> void:
	super()
	if _ended():
		return

	# check if defendable is deleted (destroyed) 
	# or removed from the tree (if the object wasn't removed from the memory)
	if not is_instance_valid(defendable) or not defendable.is_inside_tree():
		state = MissionState.FAILED

## called by the timer
## to signal the success of the mission
func success() -> void:
	print("succesfuly defended!")
	state = MissionState.FINISHED
