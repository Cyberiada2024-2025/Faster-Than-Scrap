class_name VortexWarning
extends Control

## Class that displays a warning when the player is about to fly into the vortex,
## or when the vortex is nearby. When inside the vortex, it will also show danger.

enum WarningState { PLAYER_SAFE, WARNING, DANGER }

@export_category("Warning objects")
## Container for control nodes which will be hidden/revealed according to warning state.
@export var warning_objects_container: Control
## Control node which will be hidden/revealed when in danger state.
@export var danger_object: Control

@export_category("Warning parameters")
## If player with current velocity will fly into vortex in time_to_enter_vortex seconds,
## warning will be displayed
@export var time_to_enter_vortex: float = 2
## Distance from the edge of vortex to start displaying warning
@export var distance_from_vortex_edge: float = 10
## Speed of alpha canal modulation of [member VortexWarning.danger_object]
## and [member VortexWarning.warning_objects_container]
@export_range(0.01, 2) var warning_reveal_speed: float = 0.1

@export_category("Warning materials")
@export var warning_material: Material
@export var danger_material: Material

var warning_state: WarningState = WarningState.PLAYER_SAFE


func _ready() -> void:
	warning_objects_container.modulate.a = 0
	danger_object.modulate.a = 0


func _process(delta: float) -> void:
	# check if there is vortex
	if SpaceVortex.instance == null:
		return

	match warning_state:
		WarningState.PLAYER_SAFE:
			_hide_warning(delta)
			_hide_danger(delta)
			if _player_near_vortex() or _player_will_fly_into_vortex():
				_change_state(WarningState.WARNING)
		WarningState.WARNING:
			_show_warning(delta)
			_hide_danger(delta)
			if _player_in_vortex():
				_change_state(WarningState.DANGER)
			elif not (_player_near_vortex() or _player_will_fly_into_vortex()):
				_change_state(WarningState.PLAYER_SAFE)
		WarningState.DANGER:
			_show_warning(delta)
			_show_danger(delta)
			if not _player_in_vortex():
				_change_state(WarningState.WARNING)


#region warning conditions
func _player_near_vortex() -> bool:
	var player: PlayerShip = GameManager.player_ship

	var vortex_radius: float = SpaceVortex.instance.get_current_radius()
	var vortex_center: Vector3 = SpaceVortex.instance.global_position

	var player_position: Vector3 = player.global_position

	var sqr_distance = vortex_center.distance_squared_to(player_position)

	return sqr_distance >= pow(vortex_radius - distance_from_vortex_edge, 2)


# return true if player will fly into vortex with current speed
func _player_will_fly_into_vortex() -> bool:
	var player: PlayerShip = GameManager.player_ship

	var vortex_radius: float = SpaceVortex.instance.get_current_radius()
	var vortex_center: Vector3 = SpaceVortex.instance.global_position

	var player_position: Vector3 = player.global_position
	var player_speed: Vector3 = player.linear_velocity

	var predicted_player_position = player_position + player_speed * time_to_enter_vortex

	return vortex_center.distance_squared_to(predicted_player_position) >= pow(vortex_radius, 2)


func _player_in_vortex() -> bool:
	var player: PlayerShip = GameManager.player_ship

	var vortex_radius: float = SpaceVortex.instance.get_current_radius()
	var vortex_center: Vector3 = SpaceVortex.instance.global_position

	var player_position: Vector3 = player.global_position

	return vortex_center.distance_squared_to(player_position) >= pow(vortex_radius, 2)


#endregion


#region state_change
func _change_state(new_state: WarningState) -> void:
	warning_state = new_state
	match new_state:
		WarningState.PLAYER_SAFE:
			pass
		WarningState.WARNING:
			_set_warning_material(warning_material)
		WarningState.DANGER:
			_set_warning_material(danger_material)


func _set_warning_material(new_mat: Material) -> void:
	for warning_object: Control in warning_objects_container.get_children():
		warning_object.material = new_mat


func _show_warning(delta: float) -> void:
	warning_objects_container.modulate.a += delta * warning_reveal_speed
	if warning_objects_container.modulate.a > 1:
		warning_objects_container.modulate.a = 1


func _hide_warning(delta: float) -> void:
	warning_objects_container.modulate.a -= delta * warning_reveal_speed
	if warning_objects_container.modulate.a < 0:
		warning_objects_container.modulate.a = 0


func _show_danger(delta: float) -> void:
	danger_object.modulate.a += delta * warning_reveal_speed
	if danger_object.modulate.a > 1:
		danger_object.modulate.a = 1


func _hide_danger(delta: float) -> void:
	danger_object.modulate.a -= delta * warning_reveal_speed
	if danger_object.modulate.a < 0:
		danger_object.modulate.a = 0
#endregion
