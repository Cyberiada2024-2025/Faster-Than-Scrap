class_name CapturePoint
extends Area3D

signal on_capture

## The player detector will not emit any signals for this number of seconds after entering the tree,
## regardless of whether the player has entered the tree or not.
@export var instantiated_cooldown: float = 0
@export var capture_time: float = 2:
	get:
		return capture_time
	set(value):
		capture_time = value
		_capture_counter = capture_time
@export var _progress_mesh: MeshInstance3D

var _player_in_range: bool = false
var _capture_counter: float = capture_time
var _captured: bool = false


func _ready() -> void:
	body_entered.connect(_check_if_player_entered)
	body_exited.connect(_check_if_player_exited)


func _check_if_player_entered(body: Node3D) -> void:
	if body == GameManager.player_ship:
		_player_in_range = true


func _check_if_player_exited(body: Node3D) -> void:
	if body == GameManager.player_ship:
		_player_in_range = false


func _process(delta: float) -> void:
	if _captured:
		return

	if _player_in_range:
		_capture_counter -= delta
		if _capture_counter <= 0:
			_capture_counter = 0
			_captured = true
			on_capture.emit()
	else:
		_capture_counter += delta * 3
		if _capture_counter > capture_time:
			_capture_counter = capture_time

	_update_progress_bar()


func _update_progress_bar() -> void:
	if _progress_mesh == null:
		return
	var percentage: float = 1 - _capture_counter / capture_time
	_progress_mesh.set_instance_shader_parameter("percentage", percentage)
