class_name EnemyAggressive extends movementState

@export var min_range_to_target := 10
@export var extra_energy_cost: float = 10


func enter(_previous_state_path: String, _data := {}) -> void:
	pass


func state_physics_update(_delta: float) -> void:
	super(_delta)
	check_target(_delta)
	move_target_spotted(min_range_to_target)
	ship_controller.ship.use_energy(extra_energy_cost * _delta)
