class_name EnemyAggressive
extends StateNPC

@export var min_range_to_player := 10


func enter(_previous_state_path: String, _data := {}) -> void:
	pass


func state_physics_update(_delta: float) -> void:
	move_target_spotted(min_range_to_player, target)
	ship_controller.ship.energy -= 0.5
