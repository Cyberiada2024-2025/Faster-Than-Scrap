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

var mission: Mission
var unpacked_spawner: BaseEntitySpawner


func start(scene_root: Node) -> void:
	scene_root.add_child.call_deferred(mission)


func get_node_color() -> Color:
	return Color.BLACK


func get_node_description() -> String:
	return ""


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
	spawner.set_spawner(_get_spawner_points(), difficulty)
	return unpacked_spawner
