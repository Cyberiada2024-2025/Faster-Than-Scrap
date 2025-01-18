class_name ConstantFireWeapon

extends BaseWeapon

var active_projectile: Projectile = null


func _process(delta: float) -> void:
	super(delta)
	
	if active_projectile != null:
		if ship.energy >= energy_cost * delta:
			ship.energy -= energy_cost * delta
			# todo add recoil
		else:
			try_deactivate()


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


func try_deactivate() -> bool:
	if active_projectile == null:
		return false
		
	active_projectile.queue_free()
	current_cooldown = cooldown
	return true
