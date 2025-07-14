class_name SpawnerWeapon

extends BaseWeapon
@export var muzzle_flash: GPUParticles3D
@export var warning: bool
@export var apply_ship_velocity_to_projectiles: bool = true

@export_category("Projectile spread")
@export var projectiles_per_fire: int = 1
@export_range(0, 360) var spread_angle: float = 0

## Weapon that can spawn multiple projectiles, such as bullets, laser bolts, etc.


func try_activate() -> Array[Node3D]:
	if not can_activate():
		return []
	if not ship.use_energy(energy_cost):
		return []

	return _shoot()


func _shoot() -> Array[Node3D]:
	var spawned_projectiles: Array[Node3D] = []

	_current_cooldown = cooldown

	recoil.emit(recoil_force)

	for i in range(projectiles_per_fire):
		var new_projectile = _spawn_projectile()

		if apply_ship_velocity_to_projectiles and (new_projectile as Projectile != null):
			new_projectile.velocity_offset = ship.linear_velocity

		if !warning:
			new_projectile.transform = global_transform
			if projectiles_per_fire > 1:
				var angle = -spread_angle / 2 + (spread_angle / (projectiles_per_fire - 1) * i)
				new_projectile.rotate(Vector3.UP, deg_to_rad(angle))
			get_tree().current_scene.add_child(new_projectile)
		else:
			add_child(new_projectile)

		spawned_projectiles.append(new_projectile)

	if muzzle_flash != null:
		muzzle_flash.restart()
		muzzle_flash.emitting = true

	return spawned_projectiles


func can_activate() -> bool:
	if _current_cooldown > 0:
		return false
	return true
