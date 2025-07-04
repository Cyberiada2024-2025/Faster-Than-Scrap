class_name EnemyIdle
extends movementState


func enter(_previous_state_path: String, _data := {}) -> void:
	pass


func state_physics_update(_delta: float) -> void:
	super(_delta)
	# call super method (clear all forces - stay in one place)
