extends StateEnemy
class_name EnemyAggressive

@export var min_range_to_player:=10
func enter(_previous_state_path: String, _data := {}) -> void:
	# Change for closest target once we have allied NPC
	target = get_tree().get_first_node_in_group("Player")	

func state_physics_update(delta: float) -> void:
	move_target_spotted(min_range_to_player, target)
	#var vector_to_target = target.global_position - enemy.global_position
	#var direction = vector_to_target.normalized()
	#
	#if vector_to_target.length() > max_distance:
		#enemy.velocity = direction*speed*delta;
		#enemy.move_and_slide()
	#enemy.look_at(target.position)
		
