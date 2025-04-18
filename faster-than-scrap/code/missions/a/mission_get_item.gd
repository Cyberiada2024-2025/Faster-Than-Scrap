class_name MissionGetItem

extends Mission

var info: MissionInfoGetItem

var from: Node3D
var to: Node3D
var taken: bool = false

var get_item_prefab = preload("res://prefabs/environment/get_item_target.tscn")


func setup() -> void:
	super()

	# create item to take and its destinations
	from = get_item_prefab.instantiate()
	to = get_item_prefab.instantiate()

	MissionManager.get_tree().current_scene.add_child(from)
	MissionManager.get_tree().current_scene.add_child(to)

	from.global_position = info.item_position
	to.global_position = info.item_target_position
	to.hide()


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return
	if not taken:
		# check if can take
		if from.position.distance_to(GameManager.player_ship.position) < 2:
			print("caught item")
			taken = true
			to.show()
			from.hide()
	else:
		# check if in desired destination
		if to.position.distance_to(GameManager.player_ship.position) < 2:
			print("item take finished")
			state = MissionState.FINISHED
			finished.emit(self)
