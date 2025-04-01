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
