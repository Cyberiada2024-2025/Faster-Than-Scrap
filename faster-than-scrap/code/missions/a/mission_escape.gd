class_name MissionEscape

extends Mission

var info: MissionInfoEscape

var portal: Node3D

var portal_prefab = preload("res://prefabs/environment/portal.tscn")


func setup() -> void:
	super()

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
	if portal.position.distance_to(GameManager.player_ship.position) < 4:
		print("ESCAPE SUCCESS")
		state = MissionState.FINISHED
		finished.emit(self)
