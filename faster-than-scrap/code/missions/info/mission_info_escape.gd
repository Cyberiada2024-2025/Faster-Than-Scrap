class_name MissionInfoEscape

extends MissionInfo

@export var portal_position: Vector3 = Vector3.ZERO


func start(scene_root: Node) -> void:
	mission = MissionEscape.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.BLUE


func get_node_description() -> String:
	return "Mission Type:\nEscape"


func _get_default_spawner() -> PackedScene:
	return preload("res://prefabs/spawners/line_enemy_spawner.tscn")


func _get_spawner_points() -> Array[Vector3]:
	var result: Array[Vector3]
	result.push_back(GameManager.player_ship.position)
	result.push_back(portal_position)
	return result
