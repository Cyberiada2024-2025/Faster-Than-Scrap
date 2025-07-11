class_name MissionEscape

extends Mission

@export var portal_position: Node3D

var portal: PortalObject

var portal_prefab = preload("res://prefabs/environment/portal.tscn")


func setup() -> void:
	super()

	# create escape object
	portal = portal_prefab.instantiate()
	MissionManager.get_tree().current_scene.add_child.call_deferred(portal)

	# position it
	if portal_position == null:
		portal_position = get_parent().get_node("PortalPosition")
	portal.global_position = portal_position.global_position
	_spawn_vortex(portal_position.global_position)


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return
	if portal.position.distance_to(GameManager.player_ship.position) < 6:
		print("ESCAPE SUCCESS")
		state = MissionState.FINISHED
		finished.emit(self)
		portal.off()
