class_name MissionEscape

extends Mission

var portal: Node3D
var portal_position: Vector3 = Vector3.ZERO

func setup() -> void:
	super()
	var scene_root = Engine.get_main_loop().root

	# create escape object
	portal = MeshInstance3D.new() # TODO swap to instantiating the portal asset
	portal.mesh = BoxMesh.new() 
	scene_root.add_child(portal)

	# position it
	portal.global_position = portal_position

func check_finish() -> void:
	super()
	if _ended():
		return
	if portal.position.distance_to(GameManager.player_ship.position) < 4:
		state = MissionState.FINISHED
