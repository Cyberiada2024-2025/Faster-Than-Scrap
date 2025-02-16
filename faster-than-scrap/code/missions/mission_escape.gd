class_name MissionEscape

extends Mission

@export var portal_position: Vector3 = Vector3.ZERO

var portal: Node3D

func setup() -> void:
	super()

	# create escape object
	portal = MeshInstance3D.new() # TODO swap to instantiating the portal asset
	portal.mesh = BoxMesh.new()
	MissionManager.add_child(portal)

	# position it
	portal.global_position = portal_position

func check_finish() -> void:
	super()
	if _ended():
		return
	if portal.position.distance_to(GameManager.player_ship.position) < 2:
		print("ESCAPE SUCCESS")
		state = MissionState.FINISHED
