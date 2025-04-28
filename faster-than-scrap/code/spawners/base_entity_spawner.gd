class_name BaseEntitySpawner

extends Node

@export_category("Spawner")
@export var spawned_entities: Array[PackedScene]
## weights of entities, if there are none then all have equal weight
@export var entities_weights: Array[float]
@export var max_position_change: float = 0
@export var nodes_location_in_tree: Node = self
@export_group("y spawn")
@export var min_y: float = 0
@export var max_y: float = 0

var random_entity_function: Callable
var entities_count: int
var entities_distribuant: Array[float]


func _ready() -> void:
	entities_count = len(spawned_entities)
	if len(entities_weights) == 0:
		random_entity_function = _get_entity
	else:
		random_entity_function = _get_weighted_entity
		var weight_sum: float = 0
		for weight in entities_weights:
			weight_sum += weight
		entities_distribuant[0] = entities_weights[0] / weight_sum
		for i in range(1, entities_count):
			entities_distribuant[i] = entities_distribuant[i - 1] + entities_weights[i] / weight_sum


func _get_weighted_entity() -> Node:
	var r: float = randf()
	for i in range(entities_count):
		if entities_distribuant[i] >= r:
			return spawned_entities[i].instantiate()
	print("Entities spawner weight not found - return first entity")
	return spawned_entities[0].instantiate()


func _get_entity() -> Node:
	return spawned_entities[randi_range(0, len(spawned_entities) - 1)].instantiate()


func _get_base_position() -> Vector3:
	return Vector3.ZERO


func _get_position_change() -> Vector3:
	return (
		Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), randf_range(0, 2 * PI))
		* randf_range(0, max_position_change)
	)


func _get_position_y() -> float:
	return randf_range(min_y, max_y)


func spawn_entities():
	for i in range(entities_count):
		var ent: Node = random_entity_function.call()
		ent.position = _get_base_position() + _get_position_change()
		ent.position.y = _get_position_y()
		nodes_location_in_tree.add_child(ent)
