class_name Hud

extends Node3D

static var instance: Hud

@export var energy_bar: ResourceBar

@export var main_camera_offset: Vector3 = Vector3(0, 40, 0)
@export var module_camera_offset: Vector3
@export var minimap_camera_offset: Vector3 = Vector3(0, 30, 0)
@export var zoom_strength := 15
@export var zoom_time := 0.2
@export var max_zoom := 100
@export var min_zoom := 5
@export var y_pos: float = 25
@export var use_saved_fov: bool = true
## Decides the camera drag when panning
@export var panning_force: float = 2.0/3.0
## Sets the total panning area to initial viewport area + panning_viewport_extension%
## of the initial area
@export var panning_viewport_extension: float = 2.0/3.0

var _main_camera: Camera3D
var _module_camera: Camera3D
var _minimap_camera: Camera3D
var _tween: Tween
var _mouse_input: Vector2 = Vector2.ZERO
var _camera_position: Vector2 = Vector2.ZERO
var _visibility_range: Vector2


func _enter_tree() -> void:
	instance = self


func _ready() -> void:
	_main_camera = $"."
	_module_camera = $ModuleViewport/ModuleCamera
	_minimap_camera = $MinimapViewport/MinimapCamera

	if use_saved_fov and SettingsManager.zoom_level != 0:
		_main_camera.fov = SettingsManager.zoom_level

	if SettingsManager.panning_range == null:
		SettingsManager.panning_range = panning_viewport_extension \
			* _get_viewport_world_span(_main_camera)

	_visibility_range = SettingsManager.panning_range


class Rect:
	class Edge:
		var min: float
		var max: float

	var x: Edge
	var z: Edge

	func _init() -> void:
		x = Edge.new()
		z = Edge.new()

	##
	func squarify() -> void:
		var lengths: Array[float] = [
			x.max,
			-x.min,
			z.max,
			-z.min,
		]

		var longest_size = lengths.max()
		x.max = longest_size
		x.min = -longest_size
		z.max = longest_size
		z.min = -longest_size


## returns the bounding rect of a ship in local or global space
## of a ship
func _ship_bounding_rect(is_local: bool = true) -> Rect:
	var arr: Array[Vector3] = []

	if is_local:
		for module in GameManager.player_ship.modules:
			arr.append(module.position)
	else:
		for module in GameManager.player_ship.modules:
			arr.append(module.global_position)

	var result_rect: Rect = Rect.new()
	## x min
	result_rect.x.min = arr.reduce(
		func(accumulator: float, mod_position: Vector3): return min(accumulator, mod_position.x),
		INF
	)
	## x max
	result_rect.x.max = arr.reduce(
		func(accumulator: float, mod_position: Vector3): return max(accumulator, mod_position.x),
		-INF
	)
	## z min
	result_rect.z.min = arr.reduce(
		func(accumulator: float, mod_position: Vector3): return min(accumulator, mod_position.z),
		INF
	)
	## z max
	result_rect.z.max = arr.reduce(
		func(accumulator: float, mod_position: Vector3): return max(accumulator, mod_position.z),
		-INF
	)

	return result_rect


func _input(event)-> void:
	if event is InputEventMouseMotion:
		# Add relative mouse movement scaled to current viewport size
		_mouse_input += event.relative


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	# keep camera offsets relatively to player
	var player_ship = GameManager.player_ship
	_main_camera.global_position = player_ship.global_position + main_camera_offset
	_minimap_camera.global_position = player_ship.global_position + minimap_camera_offset

	## adaptive version worse effect
	#var bounding_rect: Rect = _ship_bounding_rect(false)
	## move camera to look at lower left corner of a ship
	#_module_camera.global_position.x = bounding_rect.x.min
	#_module_camera.global_position.y = 0
	#_module_camera.global_position.z = bounding_rect.z.max
	## add constant offset so the ship is always in the lower left corner
	## of a module display
	#_module_camera.global_position += module_camera_offset

	## static version (stable)
	# calculate size of a ship
	var bounding_rect: Rect = _ship_bounding_rect(false)
	# move camera to look at center of player
	_module_camera.global_position = player_ship.global_position
	# move camera to make ship stay in the middle of the radar
	# after adding/deleting modules
	_module_camera.global_position.x = (bounding_rect.x.max + bounding_rect.x.min) / 2
	_module_camera.global_position.z = (bounding_rect.z.max + bounding_rect.z.min) / 2
	# add constant offset
	_module_camera.global_position += module_camera_offset

	if Input.is_action_just_pressed("zoom_in"):
		zoom_camera(-zoom_strength)

	if Input.is_action_just_pressed("zoom_out"):
		zoom_camera(zoom_strength)

	if Input.is_action_pressed("pan_camera"):
		pan_camera(_mouse_input)

	position.y = y_pos
	_mouse_input = Vector2.ZERO


func zoom_camera(strength: int) -> void:
	var fov = clampf(_main_camera.fov + strength, min_zoom, max_zoom)
	if use_saved_fov:
		SettingsManager.zoom_level = fov
	_tween = create_tween()
	_tween.tween_property(_main_camera, "fov", fov, zoom_time)


func pan_camera(direction) -> void:
	# This variable normalizes mouse input to a given zoom level
	# Assumption: max_zoom is never zero
	var zoom_scaling_factor = _main_camera.fov / max_zoom

	var relative_camera_offset = direction \
		* zoom_scaling_factor \
		* (0.1 * panning_force)

	var xz_offset = Vector2(
		main_camera_offset.x - relative_camera_offset.x,
		main_camera_offset.z - relative_camera_offset.y
	).clamp(
		-_visibility_range,
		+_visibility_range
	)

	main_camera_offset.x = xz_offset.x
	main_camera_offset.z = xz_offset.y


## Returns a world coordinate diagonal vector that spans the whole viewport
func _get_viewport_world_span(camera) -> Vector2:
	var top_left = camera.get_viewport().get_visible_rect().position
	var btm_right = camera.get_viewport().get_visible_rect().end
	var z_depth = camera.position.y

	var world_top_left = camera.project_position(top_left, z_depth)
	var world_btm_right = camera.project_position(btm_right, z_depth)

	var world_span_3d = world_btm_right - world_top_left
	return Vector2(world_span_3d.x, world_span_3d.z)
