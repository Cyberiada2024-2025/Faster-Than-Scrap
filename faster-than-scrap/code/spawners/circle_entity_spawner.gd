class_name CircleEntitySpawner

extends BaseEntitySpawner

## certer - point [br]
## radius - max_position_change in BaseEntitySpawner
@export_category("Circle spawner points")
## center of circle
@export var point: Vector3
@export_subgroup("Circle spawner setup")
@export var circle_radius: float = 50.0
@export var circle_min_enemies: int = 5


func set_spawner(points: Array[Vector3], difficulty: int):
	while len(points) < 1:
		points.append(Vector3.ZERO)
	point = points[0]

	max_position_change = circle_radius
	entities_count = circle_min_enemies + difficulty


func _get_base_position() -> Vector3:
	return point
