class_name StateEnemy extends State


const IDLE = "Idle"
const AGGRESSIVE = "Aggressive"
const DEFENSIVE = "Defensive"

var enemy: Ship

# player or another npc
var target: Ship 

func _ready() -> void:
	await owner.ready
	enemy = owner as Ship	# getting a typed reference to controlled ship
	assert(enemy != null, "The enemy state needs the owner to be an Enemy node")
	# Change for closest target once we have allied NPC
	target = get_tree().get_first_node_in_group("Player")

func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - enemy.global_position
	var direction = vector_to_target.normalized()
	var target_basis: Basis
	
	# frame dependent
	# https://forum.godotengine.org/t/slowly-interpolate-look-at-function-for-my-enemy/100750/3
	if vector_to_target.length() > min_range_to_player:
		target_basis = Basis.looking_at(direction)
	#else:
		#target_basis = Basis.looking_at(-1 * direction)	
		
	enemy.basis = enemy.basis.slerp(target_basis, 0.04)
	enemy.velocity = enemy.speed * enemy.basis.z * -1
	enemy.move_and_slide()		
