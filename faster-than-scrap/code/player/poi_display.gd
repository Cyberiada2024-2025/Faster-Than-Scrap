class_name POIDisplay
extends Node3D

const border_offset = 10

## max distance of visibility. Outside of the poi will not be visible.
@export var max_range: float
@export var sprite: Sprite3D
@export var arrow: Sprite3D

var arrow_shown: bool = false
var initial_scale: float


func _ready() -> void:
	initial_scale = arrow.scale.x
	_hide_arrow()


func _process(delta: float) -> void:
	# prevent errors when there is no hud
	if Hud.instance == null:
		return

	if _poi_in_range():
		if _poi_visible_on_minimap():
			if arrow_shown:
				_hide_arrow()
				arrow_shown = false
		else:
			if not arrow_shown:
				_show_arrow()
				arrow_shown = true
			_set_arrow_transform()
	else:
		if arrow_shown:
			_hide_arrow()
			arrow_shown = false


## Whether POI should be visible in any way
func _poi_in_range() -> bool:
	return GameManager.player_ship.global_position.distance_to(global_position) <= max_range


func _poi_visible_on_minimap() -> bool:
	var map_camera = Hud.instance._minimap_camera
	var radius = _get_camera_radius()

	var cameraCenter = Vector2(map_camera.global_position.x, map_camera.global_position.z)
	var poiCenter = Vector2(global_position.x, global_position.z)

	# calculated on square minimap
	var distance_from_camera = _chebyshev_distance(cameraCenter, poiCenter)
	return distance_from_camera <= radius


## good measure for checking if on square
func _chebyshev_distance(a: Vector2, b: Vector2) -> float:
	var x_diff = abs(a.x - b.x)
	var y_diff = abs(a.y - b.y)
	return max(x_diff, y_diff)


## show normal circle, hide arrow
func _hide_arrow() -> void:
	# TODO CHANGE FOR APPRPIRATE HIDE
	arrow.hide()
	sprite.show()


## show arrow, hide circle
func _show_arrow() -> void:
	arrow.show()
	sprite.hide()


## set arrow position to minimap edge.
## would be much simpler on a circle :P.
func _set_arrow_transform() -> void:
	var map_camera = Hud.instance._minimap_camera
	var radius = _get_camera_radius()

	var cameraCenter = Vector2(map_camera.global_position.x, map_camera.global_position.z)
	var poiCenter = Vector2(global_position.x, global_position.z)

	var direction = (poiCenter - cameraCenter).normalized()

	# set arrow position
	_clamp_arrow_position(direction, radius)

	# set rotation
	var angle = Vector2(0, -1).angle_to(direction)
	arrow.global_rotation.y = -angle

	# set scale
	var distance = cameraCenter.distance_to(poiCenter)
	arrow.scale = Vector3.ONE * initial_scale * (1.0 - (distance - radius) / (max_range - radius))


func _clamp_arrow_position(direction: Vector2, radius: float) -> void:
	## find bigger vector component, to cast it on the square
	if abs(direction.x) > abs(direction.y):
		if direction.x == 0:
			direction *= radius
		else:
			direction *= radius / abs(direction.x)
	else:
		if direction.y == 0:
			direction *= radius
		else:
			direction *= radius / abs(direction.y)

	var map_camera = Hud.instance._minimap_camera
	var new_position: Vector3 = map_camera.global_position
	new_position.y = 0
	new_position += Vector3(direction.x, 0, direction.y)
	arrow.global_position = new_position


## camera looking downwards with certain angle view
##        .
##        |\
## height |a\   a -> angle
##        |  \
##        +---'
##         radius
func _get_camera_radius_circular() -> float:
	var map_camera = Hud.instance._minimap_camera
	var height = map_camera.global_position.y
	var angle = map_camera.fov
	var radius = height * tan(deg_to_rad(angle))
	return radius


func _get_camera_radius() -> float:
	return Hud.instance._minimap_camera.size / 2 - border_offset
