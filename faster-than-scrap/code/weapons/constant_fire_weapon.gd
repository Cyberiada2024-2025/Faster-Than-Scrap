class_name ConstantFireWeapon

extends BaseWeapon

## Weapon that spawns a single projectile at a time, such as beam, lightsaber, engine effect, etc.

var active_projectile: Projectile = null


func _process(delta: float) -> void:
	super(delta)

	if active_projectile != null:
		if ship.use_energy(energy_cost * delta):
			pass
			# todo add recoil
		else:
			try_deactivate()

## Returns whether or not the weapon can be activated.
## Takes into account [member Ship.energy], the current [member cooldown],
## and whether a spawned projectile already exists.
func can_activate() -> bool:
	if active_projectile != null:
		return false
	return super()

func try_activate() -> Projectile:
	if not can_activate():
		return null

	active_projectile = _spawn_projectile()
	add_child(active_projectile)
	return active_projectile

## Tries to deactivate the weapon. Returns whether or not it succeeded. [br]
## [method try_deactivate] will always succeed if there is an active projectile spawned,
## and fail otherwise.
func try_deactivate() -> bool:
	if active_projectile == null:
		return false

	active_projectile.queue_free()
	_current_cooldown = cooldown
	return true
