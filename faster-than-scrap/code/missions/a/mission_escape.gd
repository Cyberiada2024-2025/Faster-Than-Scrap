class_name MissionEscape

extends Mission

var info: MissionInfoEscape

var portal: Node3D


func setup() -> void:
	super()

	# create escape object
	portal = MeshInstance3D.new()  # TODO swap to instantiating the portal asset
	portal.mesh = BoxMesh.new()
	MissionManager.add_child(portal)
	MissionManager.add_mission(self)

	# position it
	portal.global_position = info.portal_position


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return
	if portal.position.distance_to(GameManager.player_ship.position) < 2:
		print("ESCAPE SUCCESS")
		state = MissionState.FINISHED
		finished.emit(self)
