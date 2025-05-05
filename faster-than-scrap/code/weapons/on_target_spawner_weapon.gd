class_name OnTargetSpawnerWeapon
extends SpawnerWeapon

@export var y_offset: float = 0


func try_activate() -> Node3D:
	var created_projectile = super()
	if created_projectile == null:
		return null

	var target = GameManager.find_closest_ship(ship)
	if target == null:
		return null
	created_projectile.global_position = target.global_position
	created_projectile.position.y += y_offset

	return created_projectile
