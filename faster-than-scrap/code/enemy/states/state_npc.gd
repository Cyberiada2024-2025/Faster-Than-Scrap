class_name StateNPC extends State


const IDLE = "Idle"
const AGGRESSIVE = "Aggressive"
const DEFENSIVE = "Defensive"

var controlledShip: Ship
var transitions: Array[baseTransition]
# player or another npc
var target: Ship 

func _ready() -> void:
	await owner.ready
	controlledShip = owner as Ship	# getting a typed reference to controlled ship
	assert(controlledShip != null, "The npc state needs the owner to be an npc node")
	 
	for transition: baseTransition in find_children("*", "baseTransition"):
		transitions.append(transition)
	
	# Change for closest target once we have allied NPC
	target = get_tree().get_first_node_in_group("Player")

func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - controlledShip.global_position
	var direction = vector_to_target.normalized()
	var target_basis: Basis
	
	# frame dependent
	# https://forum.godotengine.org/t/slowly-interpolate-look-at-function-for-my-enemy/100750/3
	if vector_to_target.length() > min_range_to_player:
		target_basis = Basis.looking_at(direction)
	#else:
		#target_basis = Basis.looking_at(-1 * direction)	
		
	controlledShip.basis = controlledShip.basis.slerp(target_basis, 0.04)
	controlledShip.velocity = controlledShip.speed * controlledShip.basis.z * -1
	controlledShip.move_and_slide()		
