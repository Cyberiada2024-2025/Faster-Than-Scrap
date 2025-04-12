class_name MissionInfo

extends Resource

## Class containg only information about the mission.
## It does not process the progress of a mission.
## Supposed to be used in the map select.

enum Priority { MAIN_QUEST, SIDE_QUEST }

@export var about: String = ""
@export var difficulty: int
@export var priority: Priority = Priority.MAIN_QUEST

var mission: Mission


func start(scene_root: Node) -> void:
	scene_root.add_child.call_deferred(mission)


func get_node_color() -> Color:
	return Color.BLACK


func get_node_description() -> String:
	return ""


func get_spawner() -> BaseEntitySpawner:
	var spawner: CircleEntitySpawner = (
		preload("res://prefabs/spawners/circle_enemy_spawner.tscn").instantiate()
	)
	spawner.point = GameManager.player_ship.position
	spawner.max_position_change = 100.0
	spawner.entities_count = 5
	return spawner
