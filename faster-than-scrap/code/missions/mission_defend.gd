class_name MissionTimedDefend

extends Mission

var defendable: Node3D
var defendable_position: Vector3=Vector3.ZERO
@export var time_to_defend: float = 60
var failed = false


func setup() -> void:
	super()
	var scene_root = Engine.get_main_loop().root
	# create defendable object
	defendable = MeshInstance3D.new() # TODO swap to instantiating the defendable asset
	defendable.mesh = BoxMesh.new() 
	scene_root.add_child(defendable)

	# add timer
	var timer := Timer.new()
	timer.wait_time = time_to_defend
	## add to tree
	timer.start()
	timer.timeout.connect(check_finish)
	scene_root.add_child(timer)

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
	state = MissionState.FINISHED
