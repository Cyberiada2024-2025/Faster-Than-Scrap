extends Timer

const DAMAGE : int = 1   #DAMEGE_PER_TIMEOUT




func _on_timeout() -> void:
	self.get_parent().take_damage(DAMAGE)
