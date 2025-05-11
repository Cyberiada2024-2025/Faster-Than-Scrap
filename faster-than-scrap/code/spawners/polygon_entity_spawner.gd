class_name PolygonEntitySpawner

extends BaseEntitySpawner

@export_category("Polygon spawner points")
@export var points: Array[Vector3]

var polygon: PackedVector2Array = []


func _set_polygon() -> void:
	for point in points:
		polygon.append(Vector2(point.x, point.z))
	print(polygon)


func _is_point_in_border(point: Vector3) -> bool:
	return Geometry2D.is_point_in_polygon(Vector2(point.x, point.z), polygon)


func _set_spawn_points() -> void:
	_add_points(points[0])


func set_points(points: Array[Vector3]) -> void:
	while len(points) < 3:
		points.append(Vector3.ZERO)
	self.points = points
	_set_polygon()
