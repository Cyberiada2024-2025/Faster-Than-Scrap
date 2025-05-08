class_name MissionInfoFuel

extends MissionInfo

@export var fuel_position: Vector3 = Vector3.ZERO


func start(scene_root: Node) -> void:
	mission = MissionEscape.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.YELLOW


func get_node_description() -> String:
	return "Mission Type:\nGet fuel"

func get_mission_final_target_position() -> Vector3:
	return fuel_position
