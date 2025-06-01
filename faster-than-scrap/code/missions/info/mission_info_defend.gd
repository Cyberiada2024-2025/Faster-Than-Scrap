class_name MissionInfoDefend

extends MissionInfo



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
