class_name OnTargetSpawnerWeapon
extends SpawnerWeapon

@export var y_offset: float = 0


func try_activate() -> Node3D:
	var projectile = super()
	if projectile == null:
		return null

	projectile.position.y += y_offset

	return projectile
