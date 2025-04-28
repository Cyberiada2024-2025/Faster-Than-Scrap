class_name TriangleEntitySpawner

extends BaseEntitySpawner

@export_category("Triangle Spawner")
@export var a_point: Vector3
@export var b_point: Vector3
@export var c_point: Vector3


#a + sqrt(randf()) * (-a + b + randf() * (c - b))
func _get_base_position() -> Vector3:
	return a_point + sqrt(randf()) * ((b_point - a_point) + randf() * (c_point - b_point))
