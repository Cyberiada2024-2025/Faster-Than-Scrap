class_name CircleEntitySpawner

extends BaseEntitySpawner

@export_category("Circle Spawner")
@export var point: Vector3


func _get_base_position() -> Vector3:
	return point
