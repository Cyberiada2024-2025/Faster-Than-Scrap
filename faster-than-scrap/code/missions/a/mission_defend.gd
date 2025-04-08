class_name MissionTimedDefend

extends Mission

@export var info: MissionInfoDefend

var defendable: Node3D
var failed = false

var defend_prefab = preload("res://prefabs/environment/defend_target.tscn")


func setup() -> void:
	super()

	# create defendable object
	# TODO swap to instantiating the defendable asset f.e.: ally ship
	defendable = defend_prefab.instantiate()
	MissionManager.get_tree().current_scene.add_child(defendable)

	# add timer
	var timer := Timer.new()
	# add to tree
	timer.timeout.connect(success)
	MissionManager.get_tree().current_scene.add_child(timer)
	timer.start(info.time_to_defend)

	# position it
	defendable.global_position = info.defendable_position


func _process(_delta: float) -> void:
	super(_delta)
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
	finished.emit(self)
