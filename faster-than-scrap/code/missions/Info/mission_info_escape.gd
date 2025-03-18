class_name MissionInfoEscape

extends MissionInfo

@export var portal_position: Vector3 = Vector3.ZERO


func start() -> void:
	mission = MissionEscape.new()
	mission.info = self
	super()


func get_node_color() -> Color:
	return Color.BLUE

func get_node_description() -> String:
	return "Mission Type:\nEscape"
