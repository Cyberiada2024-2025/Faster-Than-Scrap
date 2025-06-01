class_name MissionTimedDefend

extends Mission

@export_category("Main defendable")
@export var defendable_position: Vector3 = Vector3.ZERO
@export var time_to_defend: float = 20
@export var defend_prefab = preload("res://prefabs/environment/defend_target.tscn")

@export_category("Small defendables")
@export var small_defendable_position: Array[Vector3] = []
@export var small_time_to_defend: float = 5
@export var small_defend_prefab = preload("res://prefabs/environment/defend_target_small.tscn")

var _capture_counter: int = 1


func setup() -> void:
	super()

	# create defendable object
	# TODO swap to instantiating the defendable asset f.e.: ally ship

	_capture_counter = 1

	_spawn_defendable()
	_spawn_small_defendables()


func _spawn_defendable() -> void:
	# main defendable
	var defendable: CapturePoint = defend_prefab.instantiate()
	MissionManager.get_tree().current_scene.add_child(defendable)
	defendable.global_position = defendable_position
	defendable.on_capture.connect(_on_capture)
	defendable.capture_time = time_to_defend


func _spawn_small_defendables() -> void:
	# smaller defendables
	for small_defendable_pos in info.small_defendable_position:
		var small_defendable: CapturePoint = info.small_defend_prefab.instantiate()
		MissionManager.get_tree().current_scene.add_child(small_defendable)
		small_defendable.global_position = small_defendable_pos
		small_defendable.on_capture.connect(_on_capture)
		small_defendable.capture_time = info.small_time_to_defend
		_capture_counter += 1


## called by the timer
## to signal the success of the mission
func _on_capture() -> void:
	print("succesfuly defended!")
	_capture_counter -= 1
	if _capture_counter == 0:
		state = MissionState.FINISHED
		finished.emit(self)
