class_name SpawnerInAreaWeapon
extends SpawnerWeapon

@export var spawn_count: int = 1
@export var min_range: float = 0
@export var max_range: float = 20


func try_activate() -> Node3D:
	var created_projectile := super()
	if created_projectile == null:
		return null

	var target = GameManager.find_closest_ship(ship)
	if target == null:
		return null

	var random = RandomNumberGenerator.new()
	created_projectile.position += get_random_point_in_donut()

	# spawn multiple if needed
	for index in range(spawn_count - 2):
		var copy: Node3D = created_projectile.duplicate()
		copy.position += get_random_point_in_donut()

	return created_projectile


func get_random_point_in_donut() -> Vector3:
	var angle = randf() * TAU  # TAU = 2 * PI
	var r = lerp(min_range, max_range, randf())
	return Vector3(cos(angle), 0, sin(angle)) * r
