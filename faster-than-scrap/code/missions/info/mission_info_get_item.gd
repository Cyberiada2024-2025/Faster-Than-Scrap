class_name MissionInfoGetItem

extends MissionInfo

@export var item_position: Vector3 = Vector3.ZERO
@export var item_target_position: Vector3 = Vector3.ZERO


func start(scene_root: Node) -> void:
	mission = MissionGetItem.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.PURPLE


func get_node_description() -> String:
	return "Mission Type:\nGet item"


func _get_default_spawner() -> PackedScene:
	return preload("res://prefabs/spawners/triangle_enemy_spawner.tscn")


func _get_spawner_points() -> Array[Vector3]:
	var result: Array[Vector3]
	result.push_back(GameManager.player_ship.position)
	result.push_back(item_position)
	result.push_back(item_target_position)
	return result
