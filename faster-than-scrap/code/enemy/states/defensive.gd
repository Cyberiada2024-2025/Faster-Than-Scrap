extends StateEnemy
class_name EnemyDefensive

@export var min_range_to_player:= 25
func enter(_previous_state_path: String, _data := {}) -> void:
	#set parameters
	pass

func state_physics_update(_delta: float) -> void:
	move_target_spotted(min_range_to_player, target)
	enemy.energy += 0.5
	if enemy.energy > 90:
		finished.emit(AGGRESSIVE)
	pass
