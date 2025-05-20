class_name MissionInfoDefend

extends MissionInfo

@export_category("Main defendable")
@export var defendable_position: Vector3 = Vector3.ZERO
@export var time_to_defend: float = 20
@export var defend_prefab = preload("res://prefabs/environment/defend_target.tscn")

@export_category("Small defendables")
@export var small_defendable_position: Array[Vector3] = []
@export var small_time_to_defend: float = 5
@export var small_defend_prefab = preload("res://prefabs/environment/defend_target_small.tscn")


func start(scene_root: Node) -> void:
	mission = MissionTimedDefend.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.GREEN


func get_node_description() -> String:
	return "Mission Type:\nDefend"


func get_mission_final_target_position() -> Vector3:
	return defendable_position
