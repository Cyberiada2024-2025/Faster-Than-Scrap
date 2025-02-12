extends StateEnemy
class_name EnemyAggressive

# player or another npc
@export var target: Ship 

# should inherit speed from Ship node
@export var speed: float
@export var max_distance: float
func enter(_previous_state_path: String, _data := {}) -> void:
	#set parameters
	target = get_tree().get_first_node_in_group("Player")

func state_physics_update(delta: float) -> void:
	var vector_to_target = target.global_position - enemy.global_position
	var direction = vector_to_target.normalized()
	
	if vector_to_target.length() > max_distance:
		#enemy.position += direction * speed * delta
		enemy.velocity = direction*speed*delta;
		enemy.move_and_slide()
	enemy.look_at(target.position)
	#else:
		#enemy.velocity = Vector3()
		
