class_name EnemyAgressiveShooting extends EnemyAggressive

func enter(_previous_state_path: String, _data := {}) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	super(_delta)
	ship_controller.weapon.try_activate()
