class_name MissionGetItem

extends Mission

var from: Node3D
var to: Node3D
var taken: bool = false

var item_position: Vector3 = Vector3.ZERO
var item_target_position: Vector3 = Vector3.ZERO

func setup() -> void:
	super()
	var scene_root = Engine.get_main_loop().root

	# create item to take and its destinations
	from = MeshInstance3D.new() # TODO swap to instantiating the item asset
	to = MeshInstance3D.new()
	from.mesh = BoxMesh.new()
	to.mesh = BoxMesh.new() 

	scene_root.add_child(from)
	scene_root.add_child(to)

	from.global_position = item_position
	to.global_position = item_target_position

func check_finish() -> void:
	super()
	if _ended():
		return
	if not taken:
		# check if can take
		if from.position.distance_to(GameManager.player_ship.position) < 4:
			taken = true
	else:
		# check if in desired destination
		if to.position.distance_to(GameManager.player_ship.position) < 4:
			state = MissionState.FINISHED
