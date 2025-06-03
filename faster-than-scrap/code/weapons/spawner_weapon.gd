class_name SpawnerWeapon

extends BaseWeapon
@export var muzzle_flash: GPUParticles3D
@export var warning: bool
@export var apply_ship_velocity_to_projectiles: bool = true

## Weapon that can spawn multiple projectiles, such as bullets, laser bolts, etc.


func try_activate() -> Node3D:
	if not can_activate():
		return null

	_current_cooldown = cooldown
	ship.use_energy(energy_cost)
	recoil.emit(recoil_force)

	var new_projectile = _spawn_projectile()

	if apply_ship_velocity_to_projectiles and (new_projectile as Projectile != null):
		new_projectile.velocity_offset = ship.linear_velocity

	if !warning:
		new_projectile.transform = global_transform
		get_tree().current_scene.add_child(new_projectile)
	else:
		add_child(new_projectile)

	if muzzle_flash != null:
		muzzle_flash.restart()
		muzzle_flash.emitting = true

	return new_projectile
