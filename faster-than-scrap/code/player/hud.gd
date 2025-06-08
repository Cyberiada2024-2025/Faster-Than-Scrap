class_name Hud

extends Node3D

static var instance: Hud

@export var energy_bar: ResourceBar

@export var main_camera_offset: Vector3 = Vector3(0, 40, 0)
@export var module_camera_offset: Vector3 = Vector3(10, 10, -10)
@export var module_camera_zoom_strength := 5
@export var minimap_camera_offset: Vector3 = Vector3(0, 30, 0)
@export var zoom_strength := 15
@export var zoom_time := 0.2
@export var max_zoom := 100
@export var min_zoom := 50
@export var y_pos: float = 25

var _main_camera: Camera3D
var _module_camera: Camera3D
var _minimap_camera: Camera3D
var _tween: Tween


func _enter_tree() -> void:
	instance = self


func _ready() -> void:
	_main_camera = $"."
	_module_camera = $ModuleViewport/ModuleCamera
	_minimap_camera = $MinimapViewport/MinimapCamera


func _calculate_module_camera_size() -> float:
	var arr: Array[float] = []
	var center = GameManager.player_ship.position

	for module in GameManager.player_ship.modules:
		arr.append(abs(center.x - module.position.x))
		arr.append(abs(center.z - module.position.z))
	return arr.max()


func _module_camera_offset_x() -> float:
	var arr: Array[float] = []
	var center = GameManager.player_ship.position

	for module in GameManager.player_ship.modules:
		arr.append(center.x - module.position.x)
	return arr.max()


func _module_camera_offset_z() -> float:
	var arr: Array[float] = []
	var center = GameManager.player_ship.position

	for module in GameManager.player_ship.modules:
		arr.append(center.z + module.position.z)
	return arr.max()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	# keep camera offsets relatively to player
	var player_ship = GameManager.player_ship
	_main_camera.global_position = player_ship.global_position + main_camera_offset
	_module_camera.global_position = player_ship.global_position + module_camera_offset
	_minimap_camera.global_position = player_ship.global_position + minimap_camera_offset
	_module_camera.position.x = _module_camera_offset_x() * -1
	_module_camera.position.z = _module_camera_offset_z()
	_module_camera.position += module_camera_offset
	if Input.is_action_just_pressed("zoom_in"):
		zoom_camera(-zoom_strength)

	if Input.is_action_just_pressed("zoom_out"):
		zoom_camera(zoom_strength)

	position.y = y_pos


func zoom_camera(strength: int) -> void:
	var fov = clampf(_main_camera.fov + strength, min_zoom, max_zoom)
	_tween = create_tween()
	_tween.tween_property(_main_camera, "fov", fov, zoom_time)
