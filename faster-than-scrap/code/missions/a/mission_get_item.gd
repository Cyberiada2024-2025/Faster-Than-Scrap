class_name MissionGetItem

extends Mission

var info: MissionInfoGetItem

var from: Node3D
var to: Node3D
var taken: bool = false


func setup() -> void:
	super()

	# create item to take and its destinations
	from = MeshInstance3D.new()  # TODO swap to instantiating the item asset
	to = MeshInstance3D.new()
	from.mesh = BoxMesh.new()
	to.mesh = BoxMesh.new()

	MissionManager.add_child(from)
	MissionManager.add_child(to)

	from.global_position = info.item_position
	to.global_position = info.item_target_position


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return
	if not taken:
		# check if can take
		if from.position.distance_to(GameManager.player_ship.position) < 2:
			print("caught item")
			taken = true
	else:
		# check if in desired destination
		if to.position.distance_to(GameManager.player_ship.position) < 2:
			print("item take finished")
			state = MissionState.FINISHED
			finished.emit(self)
