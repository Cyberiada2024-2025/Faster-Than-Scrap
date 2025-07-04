class_name MissionTimedDefend

extends Mission

@export_category("Main defendable")
@export var defendable_position: Array[Node3D]
@export var time_to_defend: float = 10
@export var defend_prefab = preload("res://prefabs/environment/mission_related/defend_target.tscn")

@export_category("Small defendables")
@export var small_defendable_position: Array[Node3D] = []
@export var small_time_to_defend: float = 4
@export var small_defend_prefab = preload(
	"res://prefabs/environment/mission_related/defend_target_small.tscn"
)

var _capture_counter: int = 0

var _defend_tutorial_cutscene = preload(
	"res://prefabs/ui/cutscenes/tutorials/missions/defend_tutorial.tscn"
)


func setup() -> void:
	super()

	# create defendable objects

	_capture_counter = 0

	_spawn_defendable()
	_spawn_small_defendables()
	# different way to set center might be preferable
	_spawn_vortex(defendable_position[0].global_position)

	CutsceneManager.play_cutscene(_defend_tutorial_cutscene)


func _spawn_defendable() -> void:
	# main defendable
	if defendable_position.is_empty():
		defendable_position.append(get_parent().get_node("PortalPosition"))

	for defendable_pos in defendable_position:
		var defendable: CapturePoint = defend_prefab.instantiate()
		MissionManager.get_tree().current_scene.add_child.call_deferred(defendable)
		defendable.global_position = defendable_pos.global_position
		defendable.on_capture.connect(_on_capture)
		defendable.capture_time = time_to_defend
		_capture_counter += 1


func _spawn_small_defendables() -> void:
	# smaller defendables
	for small_defendable_pos in small_defendable_position:
		var small_defendable: CapturePoint = small_defend_prefab.instantiate()
		MissionManager.get_tree().current_scene.add_child.call_deferred(small_defendable)
		small_defendable.global_position = small_defendable_pos.global_position
		small_defendable.on_capture.connect(_on_capture)
		small_defendable.capture_time = small_time_to_defend
		_capture_counter += 1


## called by the timer
## to signal the success of the mission
func _on_capture() -> void:
	print("succesfuly defended!")
	_capture_counter -= 1
	if _capture_counter == 0:
		await get_tree().create_timer(2.0).timeout
		state = MissionState.FINISHED
		finished.emit(self)
