@tool
class_name BossNode

extends MapNode

@export var mission_info: MissionInfo = MissionInfo.new()
@export var boss_prefabs: Array[PackedScene] = []
@export var is_miniboss = false


func get_description() -> String:
	return mission_info.get_node_description()


func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	BossManager.bosses_to_spawn = boss_prefabs
	BossManager.is_miniboss = is_miniboss
	scene_loader.load_boss_scene(Vector3(0, 0, 60))
