class_name TriangleEntitySpawner

extends BaseEntitySpawner

@export_category("Triangle Spawner")
@export var a_point: Vector3
@export var b_point: Vector3
@export var c_point: Vector3


#a + sqrt(randf()) * (-a + b + randf() * (c - b))
func spawn_entities():
	for i in range(entities_count):
		var ent: Node = spawned_entities[randi_range(0, len(spawned_entities) - 1)].instantiate()
		ent.position = (
			a_point + sqrt(randf()) * ((b_point - a_point) + randf() * (c_point - b_point))
		)
		ent.position += (
			Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), randf_range(0, 2 * PI))
			* randf_range(0, max_position_change)
		)
		ent.position.y = randf_range(min_y, max_y)
		nodes_location_in_tree.add_child(ent)
