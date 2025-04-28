class_name LineEntitySpawner

extends BaseEntitySpawner

@export_category("Line Spawner")
@export var start_point: Vector3
@export var end_point: Vector3


func _get_base_position() -> Vector3:
	return start_point + randf() * (end_point - start_point)
