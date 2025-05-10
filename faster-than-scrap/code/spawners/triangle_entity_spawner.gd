class_name TriangleEntitySpawner

extends BaseEntitySpawner

@export_category("Triangle spawner points")
@export var a_point: Vector3
@export var b_point: Vector3
@export var c_point: Vector3

@export_subgroup("Triangle spawner setup")
@export var triangle_max_position_change: float = 0
@export var triangle_difficulty_bonus_enemy: int = 2
@export var triangle_area_per_enemy_groups: int = 200
@export var triangle_min_enemy: int = 4


func set_spawner(points: Array[Vector3], difficulty: int):
	while len(points) < 3:
		points.append(Vector3.ZERO)
	a_point = points[0]
	b_point = points[1]
	c_point = points[2]

	max_position_change = triangle_max_position_change
	entities_count = (
		triangle_min_enemy
		+ (
			(triangle_difficulty_bonus_enemy + difficulty)
			* abs(
				(
					(
						a_point.x * (b_point.z - c_point.z)
						+ b_point.x * (c_point.z - a_point.z)
						+ c_point.x * (a_point.z - b_point.z)
					)
					/ 2
					/ triangle_area_per_enemy_groups
				)
			)
		)
	)


#a + sqrt(randf()) * (-a + b + randf() * (c - b))
func _get_base_position() -> Vector3:
	return a_point + sqrt(randf()) * ((b_point - a_point) + randf() * (c_point - b_point))
