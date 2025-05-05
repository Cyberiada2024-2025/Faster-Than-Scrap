class_name OnTargetSpawnerWeapon
extends SpawnerWeapon

@export var y_offset: float = 0


func try_activate() -> Node3D:
	var projectile = super()
	if projectile == null:
		return null

	var target = GameManager.find_closest_ship(ship)
	if target == null:
		return null
	projectile.global_position = target.global_position
	projectile.position.y += y_offset

	return projectile
