extends StateEnemy

@export var min_range_to_player:= 25
func enter(_previous_state_path: String, _data := {}) -> void:
	#set parameters
	pass

func physics_update(_delta: float) -> void:
	move_target_spotted(min_range_to_player, target)
	pass
