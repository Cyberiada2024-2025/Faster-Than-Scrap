class_name SpawnerWeapon

extends BaseWeapon

## Weapon that can spawn multiple projectiles, such as bullets, laser bolts, etc.

@export var muzzle_flash: GPUParticles3D
@export var warning: bool
@export var apply_ship_velocity_to_projectiles: bool = true

@export_category("Projectile spread")
## Number of projectiles that will be spawned when the weapon is successfully activated.
@export var projectiles_per_fire: int = 1

## The spawned projectiles will be uniformly rotated within this angle,
## relative to the weapon's forward directon [br]
## i.e. the leftmost projectile will be rotated by [code]-spread_angle/2[/code]
## and the rightmost by [code]spread_angle/2[/code]. [br]
## Has no effect if [member projectiles_per_fire] is equal to [code]1[/code].
@export_range(0, 360) var spread_angle: float = 0

## Random component of the fire spread angle.
## See [member random_spread_mode] for more details on how this affects the final projectiles' angle.
@export_range(0, 360) var random_spread_angle: float = 0

## Influence of the random spread angle on the final projectile angle. [br]
## [code]0[/code] means that the random component is ignored. [br]
## [code]1[/code] means that only the random component is used. [br]
## Values between are an interpolation between random and uniform angles.
@export_range(0, 1) var random_spread_influence: float = 0

## Determines how random spread angle affects the final projectile angle: [br]
## - [code]Absolute[/code] - The random spread angle is applied directly [br]
## - [code]Relative[/code] - The random spread angle is applied as an offset to the base angle
@export_enum("Absolute", "Relative") var random_spread_mode = "Absolute"


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
