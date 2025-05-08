extends Timer

const DAMAGE: float = 10  #DAMEGE_PER_TIMEOUT


func _on_timeout() -> void:
	var damageable: Damageable = self.get_parent()
	damageable.take_damage(Damage.new(DAMAGE), self)
