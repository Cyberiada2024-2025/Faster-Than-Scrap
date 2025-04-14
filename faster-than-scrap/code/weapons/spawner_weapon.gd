class_name SpawnerWeapon

extends BaseWeapon

## Weapon that can spawn multiple projectiles, such as bullets, laser bolts, etc.


func try_activate() -> Node3D:
	if not can_activate():
		return null

	_current_cooldown = cooldown
	ship.use_energy(energy_cost)
	recoil.emit(recoil_force)

	var new_projectile = _spawn_projectile()
	new_projectile.transform = global_transform
	get_tree().current_scene.add_child(new_projectile)
	return new_projectile
