class_name LineEntitySpawner

extends BaseEntitySpawner

@export_category("Line spawner points")
@export var start_point: Vector3
@export var end_point: Vector3
@export_subgroup("Line spawner setup")
@export var line_width: float = 30.0


func _is_point_in_border(point: Vector3) -> bool:
	# A = start_point.z - end_point.z
	# B = end_point.x - start_point.x
	# C = -(
	# start_point.x * (start_point.z - end_point.z)
	# + start_point.z * (end_point.x - start_point.x)
	# )
	var length: float = start_point.distance_squared_to(end_point)
	var d: float = (
		abs(
			(
				(start_point.z - end_point.z) * point.x  # A*x0
				+ (end_point.x - start_point.x) * point.z  # B*y0
				- (  # C
					start_point.x * (start_point.z - end_point.z)
					+ start_point.z * (end_point.x - start_point.x)
				)
			)
		)
		/ (sqrt((start_point.z - end_point.z) ** 2 + (end_point.x - start_point.x) ** 2))
	)
	return (
		d <= line_width / 2
		and point.distance_squared_to(start_point) <= length
		and point.distance_squared_to(end_point) <= length
	)


func _set_spawn_points() -> void:
	_add_points(start_point)


func set_spawner(points: Array[Vector3], difficulty: int):
	while len(points) < 2:
		points.append(Vector3.ZERO)
	start_point = points[0]
	end_point = points[1]
	_set_spawn_points()
	entities_count = (min_entities + int(difficulty * len(spawn_points) / points_per_entitie))


func _get_base_position() -> Vector3:
	return start_point + randf() * (end_point - start_point)
