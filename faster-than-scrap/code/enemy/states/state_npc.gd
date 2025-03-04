class_name StateNPC extends State

var controlled_ship: Ship
var transitions: Array[baseTransition]
# player or another npc
@onready var target: Ship


func _ready() -> void:
	await owner.ready
	controlled_ship = owner as Ship  # getting a typed reference to controlled ship
	assert(controlled_ship != null, "The npc state needs the owner to be an npc node")

	for transition: baseTransition in find_children("*", "baseTransition"):
		transitions.append(transition)

	# Change for closest target once we have allied NPC
	target = GameManager.player_ship


func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - controlled_ship.global_position
	var direction = vector_to_target.normalized()
	var target_basis: Basis

	# frame dependent
	# https://forum.godotengine.org/t/slowly-interpolate-look-at-function-for-my-enemy/100750/3
	if vector_to_target.length() > min_range_to_player:
		target_basis = Basis.looking_at(direction)
	#else:
	#target_basis = Basis.looking_at(-1 * direction)

	controlled_ship.basis = controlled_ship.basis.slerp(target_basis, 0.04)
	controlled_ship.velocity = controlled_ship.speed * controlled_ship.basis.z * -1
	controlled_ship.move_and_slide()
