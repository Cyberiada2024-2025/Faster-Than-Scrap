class_name POIDisplay
extends Node3D

## max distance of visibility. Outside of the poi will not be visible.
@export var max_range: float
@export var sprite: Sprite3D
@export var arrow: Sprite3D
@export var arrow_inverse_size := 25

var arrow_shown: bool = false


func _ready() -> void:
	_hide_arrow()


func _process(_delta: float) -> void:
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

	var camera_center = Vector2(map_camera.global_position.x, map_camera.global_position.z)
	var poi_center = Vector2(global_position.x, global_position.z)

	# calculated on square minimap
	var distance_from_camera = _chebyshev_distance(camera_center, poi_center)
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

	var camera_center = Vector2(map_camera.global_position.x, map_camera.global_position.z)
	var poi_center = Vector2(global_position.x, global_position.z)

	var direction = (poi_center - camera_center).normalized()

	# set arrow position
	_clamp_arrow_position(direction, radius)

	# set rotation
	arrow.look_at(Vector3(poi_center.x, 0, poi_center.y))
	arrow.rotate_object_local(Vector3.RIGHT, -PI / 2)

	# set scale
	var distance = camera_center.distance_to(poi_center)
	var arrow_size_max = Vector3.ONE * map_camera.size / arrow_inverse_size
	arrow.scale = arrow_size_max * (1.0 - (distance - radius) / (max_range - radius))


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
	var border_offset = Hud.instance._minimap_camera.size / 20
	return Hud.instance._minimap_camera.size / 2 - border_offset
