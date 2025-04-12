class_name EntitySpawner

extends Node3D

@export_category("Spawner")
@export var spawned_entities: Array[PackedScene]
@export var entities_count: int
@export var points: Array[Vector3]
@export var max_position_change: float = 0
@export var nodes_location_in_tree: Node = self.get_parent()
@export_group("y spawn")
@export var min_y: float = 0
@export var max_y: float = 0


func spawn_entities():
	if len(points) == 2:
		for i in range(entities_count):
			var ent: Node = (
				spawned_entities[randi_range(0, len(spawned_entities) - 1)].instantiate()
			)
			ent.position = (
				(points[0] + randf() * (points[1] - points[0]))
				+ (
					Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), randf_range(0, 2 * PI))
					* randf_range(0, max_position_change)
				)
			)
			ent.position.y = randf_range(min_y, max_y)
			nodes_location_in_tree.add_child(ent)
	else:
		var flat_spawn_area: Array[Vector2] = []
		for point in points:
			flat_spawn_area.append(Vector2(point.x, point.z))
		var triangles: Array[int] = Geometry2D.triangulate_polygon(flat_spawn_area)
		var triangle_areas: Array[float] = []
		for i in range(0, len(triangles), 3):
			pass
		for i in range(entities_count):
			pass
