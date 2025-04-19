class_name EnemyIdle
extends movementState

func enter(_previous_state_path: String, _data := {}) -> void:
	print("enemy is idle [zzz...]")


func state_physics_update(_delta: float) -> void:
	pass
	# idle movement
