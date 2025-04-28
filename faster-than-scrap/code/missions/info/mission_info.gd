class_name MissionInfo

extends Resource

## Class containg only information about the mission.
## It does not process the progress of a mission.
## Supposed to be used in the map select.

enum Priority { MAIN_QUEST, SIDE_QUEST }

@export var about: String = ""
@export var difficulty: int
@export var priority: Priority = Priority.MAIN_QUEST
@export_group("Spawner")
@export var spawner: PackedScene = null
@export_subgroup("Crircle spawner")
@export var circle_radius: float = 50.0
@export var circle_min_enemies: int = 5
@export_subgroup("Line spawner")
@export var line_max_position_change: float = 30.0
@export var line_difficulty_bonus_enemy: int = 2
@export var line_length_per_enemy_groups: int = 10
@export var line_min_enemy: int = 1
@export_subgroup("Triangle spawner")
@export var triangle_max_position_change: float = 0
@export var triangle_difficulty_bonus_enemy: int = 2
@export var triangle_area_per_enemy_groups: int = 200
@export var triangle_min_enemy: int = 4

var mission: Mission
var unpacked_spawner: BaseEntitySpawner


func start(scene_root: Node) -> void:
	scene_root.add_child.call_deferred(mission)


func get_node_color() -> Color:
	return Color.BLACK


func get_node_description() -> String:
	return ""


func _set_spawner_circle(p1: Vector3) -> void:
	spawner.point = p1
	spawner.max_position_change = circle_radius
	spawner.entities_count = circle_min_enemies + difficulty


func _set_spawner_line(p1: Vector3, p2: Vector3) -> void:
	spawner.start_point = p1
	spawner.end_point = p2
	spawner.max_position_change = line_max_position_change
	spawner.entities_count = (
		line_min_enemy
		+ (
			(line_difficulty_bonus_enemy + difficulty)
			* spawner.start_point.distance_to(spawner.end_point)
			/ line_length_per_enemy_groups
		)
	)


func _set_spawner_triangle(p1: Vector3, p2: Vector3, p3: Vector3) -> void:
	spawner.A_point = p1
	spawner.B_point = p2
	spawner.C_point = p3
	spawner.max_position_change = triangle_max_position_change
	spawner.entities_count = (
		triangle_min_enemy
		+ (
			(triangle_difficulty_bonus_enemy + difficulty)
			* abs(
				(
					(
						spawner.a_point.x * (spawner.b_point.z - spawner.c_point.z)
						+ spawner.b_point.x * (spawner.c_point.z - spawner.a_point.z)
						+ spawner.c_point.x * (spawner.a_point.z - spawner.b_point.z)
					)
					/ 2
					/ triangle_area_per_enemy_groups
				)
			)
		)
	)


func _set_spawner(points: Array[Vector3]) -> void:
	if unpacked_spawner is CircleEntitySpawner:
		_set_spawner_circle(points[0])
	elif unpacked_spawner is LineEntitySpawner:
		_set_spawner_line(points[0], points[1])
	elif unpacked_spawner is TriangleEntitySpawner:
		_set_spawner_triangle(points[0], points[1], points[2])


func _get_default_spawner() -> PackedScene:
	return preload("res://prefabs/spawners/circle_enemy_spawner.tscn")


func _get_spawner_points() -> Array[Vector3]:
	var result: Array[Vector3]
	result.push_back(GameManager.player_ship.position)
	return result


func get_spawner() -> BaseEntitySpawner:
	if spawner == null:
		spawner = _get_default_spawner()
	unpacked_spawner = spawner.instantiate()
	_set_spawner(_get_spawner_points())
	return unpacked_spawner
