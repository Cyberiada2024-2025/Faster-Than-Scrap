@tool
class_name Hud

extends Node3D

@export var energy_bar: ResourceBar

@export var playerShip: Node3D = null

@export var main_camera_offset: Vector3 = Vector3(0,10,0)
@export var module_camera_offset: Vector3 = Vector3(0,10,0)
@export var minimap_camera_offset: Vector3 = Vector3(0,30,0)

var _main_camera: Camera3D 
var _module_camera: Camera3D 
var _minimap_camera: Camera3D 

func _ready() -> void:
	_main_camera = $"."
	_module_camera = $ModuleViewport/ModuleCamera
	_minimap_camera = $MinimapViewport/MinimapCamera
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	# keep camera offsets relatively to player
	_main_camera.global_position = playerShip.global_position + main_camera_offset
	_module_camera.global_position = playerShip.global_position + module_camera_offset
	_minimap_camera.global_position = playerShip.global_position + minimap_camera_offset

func _get_configuration_warnings() -> PackedStringArray:
	if playerShip == null:
		return ["Field \"playerShip\" not set"]
	return []
