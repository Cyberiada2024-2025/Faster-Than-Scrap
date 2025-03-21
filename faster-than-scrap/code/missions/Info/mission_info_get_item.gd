class_name MissionInfoGetItem

extends MissionInfo

@export var item_position: Vector3 = Vector3.ZERO
@export var item_target_position: Vector3 = Vector3.ZERO


func start() -> void:
	mission = MissionGetItem.new()
	mission.info = self
	super()


func get_node_color() -> Color:
	return Color.PURPLE

func get_node_description() -> String:
	return "Mission Type:\nGet item"
