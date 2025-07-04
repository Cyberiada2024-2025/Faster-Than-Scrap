class_name baseTransition extends StateNPC

@export var new_state: State


func state_physics_update(_delta: float) -> void:
	pass
	# don't clear ship forces from transitions


func condition() -> void:
	pass
