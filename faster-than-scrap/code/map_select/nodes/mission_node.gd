@tool
class_name MissionNode

extends MapNode

@export var mission_info: MissionInfo

func _set_color() -> void:
	modulate = mission_info.get_node_color()
	super()


func get_description() -> String:
	return mission_info.get_node_description()

func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_fly_ship_scene()
