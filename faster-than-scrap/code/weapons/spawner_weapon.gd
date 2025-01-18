class_name SpawnerWeapon

extends BaseWeapon

## Weapon that can spawn multiple projectiles, such as bullets, laser bolts, etc.

## Tries to shoot. Returns the spawned projectile if it succeeded,
## and [code]null[/code] otherwise. [br]
## [method SpawnerWeapon.try_activate] can fail if [member Weapon.ship] doesn't have enough energy
## or if the [member Weapon.cooldown] time hasn't yet passed.
func try_activate() -> Projectile:
	if not can_activate():
		return null

	current_cooldown = cooldown
	ship.energy -= energy_cost
	# todo: add recoil to the ship

	var new_projectile = _spawn_projectile()
	new_projectile.transform = global_transform
	get_tree().get_root().add_child(new_projectile)
	return new_projectile
