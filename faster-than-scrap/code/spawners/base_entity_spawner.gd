class_name BaseEntitySpawner

extends Node

@export_category("Spawner")
## node to which spawned entity will be added as a child
@export var nodes_location_in_tree: Node = self
@export_group("Baned Areas")
@export var baned_circles_centers: Array[Vector3] = []
@export var baned_circles_radiuses: Array[float] = []
@export_group("Entities")
@export var spawned_entities: Array[PackedScene] = []
## weights of entities, if there are none then all have equal weight
@export var entities_weights: Array[float] = []
## minimum distance betwen spawned entities
@export var entities_distane: float = 20.0
@export_subgroup("Entities Count")
@export var min_entities: int = 10
@export var points_per_entitie: float = 20
## limits of random y position
@export_group("y spawn")
@export var min_y: float = 0
@export var max_y: float = 0

var random_entity_function: Callable
var entities_count: int
var entities_instances: int
var entities_distribuant: Array[float]

var spawn_points: Array[Vector3] = []


func add_baned_circle(center: Vector3, radius: float) -> void:
	baned_circles_centers.append(center)
	baned_circles_radiuses.append(radius)


func _is_point_not_added(point: Vector3) -> bool:
	const FLOAT_TOLERANCE = 0.01
	for added in spawn_points:
		if abs(point.x - added.x) < FLOAT_TOLERANCE and abs(point.z - added.z) < FLOAT_TOLERANCE:
			return false
	return true


func _is_point_in_baned_area(point: Vector3) -> bool:
	for i in range(len(baned_circles_centers)):
		if (
			(
				(baned_circles_centers[i].x - point.x) ** 2
				+ (baned_circles_centers[i].z - point.z) ** 2
			)
			< baned_circles_radiuses[i] ** 2
		):
			return true
	return false


func _is_point_in_border(_point: Vector3) -> bool:
	return false


func _add_points(start_point: Vector3) -> void:
	var to_add: Array[Vector3] = []
	to_add.append(start_point)

	var point: Vector3
	while not to_add.is_empty():
		point = to_add.pop_back()
		if _is_point_not_added(point) and _is_point_in_border(point):
			spawn_points.append(point)
			var new_point: Vector3 = Vector3(entities_distane, 0, 0)
			to_add.append(point + new_point)
			new_point = new_point.rotated(Vector3(0, 1, 0), PI / 3)
			to_add.append(point + new_point)
			new_point = new_point.rotated(Vector3(0, 1, 0), PI / 3)
			to_add.append(point + new_point)
			new_point = new_point.rotated(Vector3(0, 1, 0), PI / 3)
			to_add.append(point + new_point)
			new_point = new_point.rotated(Vector3(0, 1, 0), PI / 3)
			to_add.append(point + new_point)
			new_point = new_point.rotated(Vector3(0, 1, 0), PI / 3)
			to_add.append(point + new_point)


func _set_spawn_points() -> void:
	pass


func _ready() -> void:
	entities_instances = len(spawned_entities)
	if len(entities_weights) == 0:
		random_entity_function = _get_entity
	else:
		random_entity_function = _get_weighted_entity
		var weight_sum: float = 0
		for weight in entities_weights:
			weight_sum += weight
		entities_distribuant[0] = entities_weights[0] / weight_sum
		for i in range(1, entities_instances):
			entities_distribuant[i] = entities_distribuant[i - 1] + entities_weights[i] / weight_sum


func _get_weighted_entity() -> Node:
	var r: float = randf()
	for i in range(entities_instances):
		if entities_distribuant[i] >= r:
			return spawned_entities[i].instantiate()
	print("Entities spawner weight not found - return first entity")
	return spawned_entities[0].instantiate()


func _get_entity() -> Node:
	return spawned_entities.pick_random().instantiate()


func _get_position_y() -> float:
	return randf_range(min_y, max_y)


func set_points(_points: Array[Vector3]) -> void:
	pass


func start_spawner(difficulty: int) -> void:
	_set_spawn_points()
	entities_count = (min_entities + int(difficulty * len(spawn_points) / points_per_entitie))


func set_spawner(points: Array[Vector3], difficulty: int):
	set_points(points)
	start_spawner(difficulty)
	_ready()


func spawn_entities():
	print("SPAWNING")
	var positions: Array[Vector3] = spawn_points.duplicate(true)
	positions.shuffle()
	#print(len(positions))
	print(entities_count)
	for i in range(entities_count):
		var point = positions.pop_back()
		while point != null and _is_point_in_baned_area(point):
			point = positions.pop_back()
		if point == null:
			print("NOT ENOUGHT SPACE TO SPAWN")
			break
		var ent: Node = random_entity_function.call()
		ent.position = point
		ent.position.y = _get_position_y()
		nodes_location_in_tree.add_child(ent)
