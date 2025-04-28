class_name CircleEntitySpawner

extends BaseEntitySpawner

## certer - point [br]
## radius - max_position_change in BaseEntitySpawner
@export_category("Circle Spawner")
## center of circle
@export var point: Vector3


func _get_base_position() -> Vector3:
	return point
