class_name MissionInfoDefend

extends MissionInfo

@export var defendable_position: Vector3 = Vector3.ZERO
@export var time_to_defend: float = 60


func start(scene_root: Node) -> void:
	mission = MissionTimedDefend.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.GREEN


func get_node_description() -> String:
	return "Mission Type:\nDefend"


func _get_default_spawner() -> PackedScene:
	return preload("res://prefabs/spawners/line_enemy_spawner.tscn")


func _get_spawner_points() -> Array[Vector3]:
	var result: Array[Vector3]
	result.push_back(GameManager.player_ship.position)
	result.push_back(defendable_position)
	return result
