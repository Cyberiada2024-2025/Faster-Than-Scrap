class_name MissionInfoDefend

extends MissionInfo

@export var defendable_position: Vector3 = Vector3.ZERO
@export var time_to_defend: float = 60


func start(scene_root: Node) -> void:
	mission = MissionTimedDefend.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.GREEN


func get_node_description() -> String:
	return "Mission Type:\nDefend"
