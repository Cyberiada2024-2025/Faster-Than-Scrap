class_name TriangleEntitySpawner

extends BaseEntitySpawner

@export_category("Triangle Spawner")
@export var A_point: Vector3
@export var B_point: Vector3
@export var C_point: Vector3


#a + sqrt(randf()) * (-a + b + randf() * (c - b))
func spawn_entities():
	for i in range(entities_count):
		var ent: Node = spawned_entities[randi_range(0, len(spawned_entities) - 1)].instantiate()
		ent.position = (
			A_point + sqrt(randf()) * ((B_point - A_point) + randf() * (C_point - B_point))
		)
		ent.position += (
			Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), randf_range(0, 2 * PI))
			* randf_range(0, max_position_change)
		)
		ent.position.y = randf_range(min_y, max_y)
		nodes_location_in_tree.add_child(ent)
