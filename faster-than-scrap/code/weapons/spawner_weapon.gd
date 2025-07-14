class_name SpawnerWeapon

extends BaseWeapon
@export var muzzle_flash: GPUParticles3D
@export var warning: bool
@export var apply_ship_velocity_to_projectiles: bool = true

@export_category("Projectile spread")
@export var projectiles_per_fire: int = 1
@export_range(0, 360) var spread_angle: float = 0
@export_range(0, 360) var random_spread_angle: float = 0
@export_range(0, 1) var random_spread_influence: float = 0
@export_enum("Absolute", "Relative") var random_spread_mode = "Absolute"

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

			_rotate_projectile(new_projectile, i)

			get_tree().current_scene.add_child(new_projectile)
		else:
			add_child(new_projectile)

		spawned_projectiles.append(new_projectile)

	if muzzle_flash != null:
		muzzle_flash.restart()
		muzzle_flash.emitting = true

	return spawned_projectiles


func _rotate_projectile(projectile: Node3D, projectile_index: int):
	var angle = 0
	if projectiles_per_fire > 1:
		angle = -spread_angle / 2 + (spread_angle / (projectiles_per_fire - 1) * projectile_index)

	var random_angle = randf_range(-random_spread_angle / 2, random_spread_angle / 2)
	match random_spread_mode:
		"Absolute":
			angle = (random_angle * random_spread_influence + angle * (1 - random_spread_influence))
		"Relative":
			angle += random_angle * random_spread_influence

	projectile.rotate(Vector3.UP, deg_to_rad(angle))


func can_activate() -> bool:
	if _current_cooldown > 0:
		return false
	return true
