class_name MissionInfoEscape

extends MissionInfo

@export var portal_position: Vector3 = Vector3.ZERO


func start() -> void:
	mission = MissionEscape.new()
	mission.info = self
	super()
