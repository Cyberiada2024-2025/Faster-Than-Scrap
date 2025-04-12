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


func get_target_position() -> Vector3:
	return item_position
