class_name KnockedOut
extends StateNPC


func enter(_previous_state_path: String, _data := {}) -> void:
	pass


func state_physics_update(_delta: float) -> void:
	pass
	# don't change any forces
	# (not calling super of StateNPC.state_physics_update method) - free rigidbody movement
