@tool
class_name MissionNode

extends MapNode

@export var mission_info: MissionInfo = MissionInfo.new()
@export var level_prefab: PackedScene
@export var modulate_color: Color


func _set_color() -> void:
	if Engine.is_editor_hint():
		return
	if mission_info != null:
		# Totally don't know why this line prints error in tool
		# (shows error Nonexistent function, even though it exists :/)
		self_modulate = modulate_color
	super()


func get_description() -> String:
	return mission_info.get_node_description()


func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_fly_ship_scene(level_prefab)
