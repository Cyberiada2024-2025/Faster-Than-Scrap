class_name LineEntitySpawner

extends BaseEntitySpawner

@export_category("Line spawner points")
@export var start_point: Vector3
@export var end_point: Vector3
@export_subgroup("Line spawner setup")
@export var line_max_position_change: float = 30.0
@export var line_difficulty_bonus_enemy: int = 2
@export var line_length_per_enemy_groups: int = 10
@export var line_min_enemy: int = 1


func set_spawner(points: Array[Vector3], difficulty: int):
	while len(points) < 2:
		points.append(Vector3.ZERO)
	start_point = points[0]
	end_point = points[1]

	max_position_change = line_max_position_change
	entities_count = (
		line_min_enemy
		+ int(
			(
				(line_difficulty_bonus_enemy + difficulty)
				* start_point.distance_to(end_point)
				/ line_length_per_enemy_groups
			)
		)
	)


func _get_base_position() -> Vector3:
	return start_point + randf() * (end_point - start_point)
