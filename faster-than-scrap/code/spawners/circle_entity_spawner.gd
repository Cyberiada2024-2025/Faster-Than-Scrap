class_name CircleEntitySpawner

extends BaseEntitySpawner

## certer - point [br]
## radius - max_position_change in BaseEntitySpawner
@export_category("Circle spawner points")
## center of circle
@export var center: Vector3
@export_subgroup("Circle spawner setup")
@export var circle_radius: float = 50.0


func _is_point_in_border(point: Vector3) -> bool:
	return (point.x - center.x) ** 2 + (point.z - center.z) ** 2 <= circle_radius ** 2


func _set_spawn_points() -> void:
	_add_points(center)


func set_points(points: Array[Vector3]) -> void:
	while len(points) < 1:
		points.append(Vector3.ZERO)
	center = points[0]
