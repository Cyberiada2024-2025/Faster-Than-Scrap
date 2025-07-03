class_name StateNPC extends State

var ship_controller: ShipController
var transitions: Array[baseTransition]
# player or another npc
@onready var target: Ship


## Called by the state machine on the engine's physics update tick.
func state_physics_update(_delta: float) -> void:
	if ship_controller != null:
		ship_controller.linear_velocity = Vector3.ZERO
		ship_controller.angular_velocity = Vector3.ZERO


func _ready() -> void:
	await owner.ready
	ship_controller = owner as ShipController  # getting a typed reference to controlled ship
	assert(ship_controller != null, "The npc state needs the owner to be an npc node")

	for transition: baseTransition in find_children("*", "baseTransition"):
		transitions.append(transition)

	# code for no target found
	target = ship_controller.ship
