extends StateEnemy
class_name EnemyIdle

@export var min_range_to_player:=50
func enter(_previous_state_path: String, _data := {}) -> void:
	print("enemy is idle [zzz...]")
	pass

func state_physics_update(_delta: float) -> void:
	var vector_to_target = target.global_position - enemy.global_position
	if vector_to_target.length() < min_range_to_player: 
		finished.emit(AGGRESSIVE)
