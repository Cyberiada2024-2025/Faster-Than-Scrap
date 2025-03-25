class_name StateNPC extends State

var ship_controller: ShipController
var transitions: Array[baseTransition]
# player or another npc
@onready var target: Ship


func _ready() -> void:
	await owner.ready
	ship_controller = owner as ShipController  # getting a typed reference to controlled ship
	assert(ship_controller != null, "The npc state needs the owner to be an npc node")

	for transition: baseTransition in find_children("*", "baseTransition"):
		transitions.append(transition)

	# Change for closest target once we have allied NPC
	target = GameManager.player_ship


func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - ship_controller.global_position
	var direction = vector_to_target.normalized()
	var target_basis: Basis

	# frame dependent
	# https://forum.godotengine.org/t/slowly-interpolate-look-at-function-for-my-enemy/100750/3
	if vector_to_target.length() > min_range_to_player:
		target_basis = Basis.looking_at(direction)
	#else:
	#target_basis = Basis.looking_at(-1 * direction)

	ship_controller.basis = ship_controller.basis.slerp(target_basis, 0.04)
	ship_controller.velocity = ship_controller.speed * ship_controller.basis.z * -1
	ship_controller.move_and_slide()
