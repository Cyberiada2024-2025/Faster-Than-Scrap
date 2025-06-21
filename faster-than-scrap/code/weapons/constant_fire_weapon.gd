class_name ConstantFireWeapon

extends BaseWeapon

## Weapon that spawns a single projectile at a time, such as beam, lightsaber, engine effect, etc.

@export var muzzle_flash: GPUParticles3D

var active_projectile: Node3D = null


func _process(delta: float) -> void:
	super(delta)

	if active_projectile != null:
		if ship.use_energy(energy_cost * delta):
			recoil.emit(delta * recoil_force)
		else:
			try_deactivate()


## Returns whether or not the weapon can be activated.
## Takes into account [member Ship.energy], the current [member cooldown],
## and whether a spawned projectile already exists.
func can_activate() -> bool:
	if active_projectile != null:
		return false
	return super()


func try_activate() -> Node3D:
	if not can_activate():
		return null

	active_projectile = _spawn_projectile()
	add_child(active_projectile)
	if muzzle_flash != null:
		muzzle_flash.emitting = true
	return active_projectile


## Tries to deactivate the weapon. Returns whether or not it succeeded. [br]
## [method try_deactivate] will always succeed if there is an active projectile spawned,
## and fail otherwise.
func try_deactivate() -> bool:
	if active_projectile == null:
		return false

	active_projectile.queue_free()
	_current_cooldown = cooldown
	if muzzle_flash != null:
		muzzle_flash.emitting = false
	return true


func force_deactivate() -> void:
	if active_projectile == null:
		return
	active_projectile.get_parent().remove_child(active_projectile)
	active_projectile.queue_free()
