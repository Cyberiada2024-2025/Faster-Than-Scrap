class_name MissionFuel

extends Mission

var info: MissionInfoFuel
# TODO: Substitute to fuel spawn
var portal: Node3D
var portal_prefab = preload("res://prefabs/environment/portal.tscn")


func setup() -> void:
	super()

	# TODO: Substitute to fuel spawn
	# create escape object
	portal = portal_prefab.instantiate()
	portal.add_child(create_label("EXIT"))
	MissionManager.get_tree().current_scene.add_child(portal)

	# position it
	portal.global_position = info.portal_position


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return

	# TODO: Substitute to fuel logic
	if portal.position.distance_to(GameManager.player_ship.position) < 4:
		print("ESCAPE SUCCESS")
		state = MissionState.FINISHED
		finished.emit(self)
