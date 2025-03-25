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
