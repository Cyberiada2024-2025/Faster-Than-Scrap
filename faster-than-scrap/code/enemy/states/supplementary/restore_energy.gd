class_name RestoreEnergy
extends StateNPC

@export var amount_per_second: float = 1

func state_physics_update(delta: float) -> void:
	ship_controller.ship.energy += amount_per_second * delta
