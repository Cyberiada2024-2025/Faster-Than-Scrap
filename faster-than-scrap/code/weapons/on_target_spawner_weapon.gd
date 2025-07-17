class_name OnTargetSpawnerWeapon
extends SpawnerWeapon

@export var y_offset: float = 0

@export_category("rotate towards target")
@export var base_radius: float = 0


func try_activate() -> Array[Node3D]:
	var created_projectiles = super()
	if created_projectiles == []:
		return []

	var target = GameManager.find_closest_ship(ship)
	if target == null:
		return []

	for created_projectile in created_projectiles:
		created_projectile.global_position = target.global_position
		created_projectile.position.y += y_offset

		var offset_2d = RandomUtils._random_on_edge_unit_circle() * base_radius
		created_projectile.global_position.x += offset_2d.x
		created_projectile.global_position.z += offset_2d.y
		created_projectile.look_at(target.global_position)

	return created_projectiles
