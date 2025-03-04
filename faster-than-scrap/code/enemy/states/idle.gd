class_name EnemyIdle
extends StateNPC

@export var min_range_to_player := 50


func enter(_previous_state_path: String, _data := {}) -> void:
	print("enemy is idle [zzz...]")


func state_physics_update(_delta: float) -> void:
	pass
	# idle movement
